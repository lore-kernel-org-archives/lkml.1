Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZCXVSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZCXVSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZCXVPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:15:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:56903 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZCXVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:15:47 -0400
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and
 make radeonfb use it
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <200903241200.37982.rjw@sisk.pl>
References: <200903210003.55161.rjw@sisk.pl>
	 <1237856239.25062.696.camel@pasglop>
	 <20090323181420.30125d59@hobbes.virtuouswap>
	 <200903241200.37982.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 08:12:55 +1100
Message-Id: <1237929175.25062.727.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 12:00 +0100, Rafael J. Wysocki wrote:

> In fact I have yet another idea.  If we use the "retransmission with exponential
> backoff" algorithm in pci_raw_set_power_state(), we won't have to add any
> extra parameters to pci_set_power_state() and the radeon case will be covered
> automatically.  That should also cover any other devices having similar
> problems IMO.
> 
> A patch to implement that is appended, please tell me what you think.

This is crazy....

Most devices don't need that and those who are a bit "touchy" may well
puke on being written to too fast while they are in the middle of
the transition.

Let's wait to see if Alex from ATI has an answer here, and if not, I
would suggest keeping the dirt inside radeonfb.

Ben.


