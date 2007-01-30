Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXA3X3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXA3X3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXA3X3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:29:09 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:3279 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXA3X3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:29:07 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="761102632:sNHT47262068"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>
	<45BFC7F2.7090209@garzik.org> <adaac00p1rq.fsf@cisco.com>
	<45BFD03F.4020003@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 15:29:02 -0800
In-Reply-To: <45BFD03F.4020003@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 18:09:51 -0500")
Message-ID: <adaps8wnlfl.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 23:29:02.0804 (UTC) FILETIME=[6D1AE140:01C744C6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > You were complaining about drivers that work on only one
 > platform. Thus, I asked for list of said drivers, drivers that break
 > Greg's pledge.

When did I ever say "one platform"?  If I did, it was an error -- I've
tried to consistently talk about not every platform.

 > I'm betting they are uniformly ancient ISA or m68k or whatnot drivers.

So what?  Greg didn't restrict his offer to "mainstream" devices.  And
Greg said "[the driver] will be automatically kept up to date and
working through all Linux kernel API changes."  Not "we'll maintain
the driver until we lose interest."  And anyway, if I dig for a few
minutes I find modern mainstream stuff like ipw2200 that is seemingly
x86-only.  (Although of course ipw2200 is straight from Intel)

 > And hooray for shifting arguments.  If this is your summary of the
 > thread, do you now concede that Greg was not being disingenuous?  Open
 > specs was not the sum toto of Greg's piece.

Perhaps "disingenous" was the wrong choice of word, though, since you
and Greg seem to sincerely believe that a spec dump is all that a
vendor needs to do.  I'll concede that maybe I should have used the
word "naive" instead.  But I absolutely feel that Greg should not be
making promises on behalf of "the Linux kernel community."

Go back and reread Greg's original email.  He said:

 > All that is needed is some kind of specification that describes how
 > your device works, or the email address of an engineer that is willing
 > to answer questions every once in a while. A few sample devices might
 > be good to have so that debugging doesn't have to be done by email,
 > but if necessary, that can be done.

Let me repeat Greg's words one more time: "All that is needed is some
kind of specification."  So I honestly don't know what you mean by
"open specs was not the sum toto of Greg's piece."

Here is what he promised once that spec is released:

 > In return, you will receive a complete and working Linux driver that
 > is added to the main Linux kernel source tree.

...

 > This driver will then be automatically included in all Linux
 > distributions, including the "enterprise" ones. It will be
 > automatically kept up to date and working through all Linux kernel
 > API changes. This driver will work with all of the different CPU
 > types supported by Linux, the largest number of CPU types supported
 > by any operating system ever before in the history of computing.

...

 > As for support, the driver will be supported through email by the
 > original developers, when they can help out, and by the
 > "enterprise" Linux distributors as part of their service agreements
 > with their customers.

...

 > This offer is in effect for all different types of devices, from USB
 > toys to PCI video devices to high-speed networking cards. If you
 > manufacture it, we can get Linux drivers working for it.

To me, it's clear that historically the community hasn't delivered on
this.  So I don't like promising something that we haven't been able
to follow through on in the past.  If a vendor takes Greg's offer, and
then the community, for whatever reason, fails to deliver on
everything, then that makes us all (including me!) look bad just
because of Greg's hyperbolic promises.

 - R.
