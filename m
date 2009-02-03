Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZBCWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZBCWeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZBCWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:34:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:37413 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZBCWeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:34:09 -0500
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200902032253.42709.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902031114321.3247@localhost.localdomain>
	 <1233695486.16867.95.camel@pasglop>  <200902032253.42709.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 09:33:10 +1100
Message-Id: <1233700390.16867.97.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 22:53 +0100, Rafael J. Wysocki wrote:

> That would change the ordering of ACPI method calls, which also is important
> and prone to breaking, as I wrote in the original message.

Ok, I'm not -that- familiar with ACPI, but I don't see where this
ordering change you seem to fear is ... Ie, what gets re-ordered vs.
what ? 

Ben.


