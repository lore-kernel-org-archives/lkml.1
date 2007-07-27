Return-Path: <linux-kernel-owner+w=401wt.eu-S937818AbXG0Uu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937818AbXG0Uu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934681AbXG0UuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:50:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32931 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934605AbXG0UuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:50:10 -0400
Message-ID: <46AA5A57.7010108@garzik.org>
Date: Fri, 27 Jul 2007 16:49:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       =?ISO-8859-15?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, serial: always probe for legacy COM ports
References: <200707271158.50028.bjorn.helgaas@hp.com> <200707271411.42253.bjorn.helgaas@hp.com> <46AA53E3.5080501@garzik.org> <200707271426.30962.bjorn.helgaas@hp.com>
In-Reply-To: <200707271426.30962.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Friday 27 July 2007 02:21:55 pm Jeff Garzik wrote:
>> Bjorn Helgaas wrote:
>>> On Friday 27 July 2007 12:05:51 pm Jeff Garzik wrote:
>>>> This is still incomplete, as repeatedly stated.  Here is the email, again.

>>> OK, uncle!  I'll work on your helpful advice (thanks for that), but
>>> it feels too risky for this stage of 2.6.23.  Maybe I can come up with
>>> something for a future release.

>> The changeset in the kernel is too risky _without_ the changes I described.
> 
> That's what I meant.  Andrew already has a revert patch in -mm, and
> the safest path seems like putting the reversion in 2.6.23 and working
> on your advice post-2.6.23.

Ah, my apologies!

I read "I'll work on your advice, but it feels too risky" as describing 
my advice as too risky, rather than the changeset currently in the kernel.

IMO the changeset should be resubmitted as two changes, separating the 
probe behavior changes from the platform driver conversion.  They are 
two distinct changes, and that would allow git-bisect to identify the 
culprit easily if future breakage occurs.

	Jeff


