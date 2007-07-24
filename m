Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXGXVji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXGXVji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXGXVja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:39:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:53760 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbXGXVja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:39:30 -0400
Subject: Re: Power Management framework proposal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707241313580.6590@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185125189.2714.13.camel@laptopd505.fenrus.org>
	 <1185229405.5439.148.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707241313580.6590@asgard.lang.hm>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 07:38:58 +1000
Message-Id: <1185313138.5439.285.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 13:14 -0700, david@lang.hm wrote:
> > I think we need a set of constraints that trickle down the power
> tree
> > and limit what a given driver can do locally.
> 
> what sort of contraints are you thinking of?

A parent power state defines what states children can be in. For
example. A way to express those dependencies would be nice. Or
alternatiely, the power state of all the children defines the power
state a parent can go in automatically.

Ben.

