Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbYGATxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbYGATxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYGATwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:52:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:58044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYGATww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:52:52 -0400
Date: Tue, 1 Jul 2008 12:51:19 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: ext Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
       ext Alan Stern <stern@rowland.harvard.edu>,
       ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
	interrupt handlers
Message-ID: <20080701195119.GA8184@kroah.com>
References: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org> <486A590A.4090806@nokia.com> <20080701182543.GA32098@suse.de> <486A823C.4070805@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A823C.4070805@nokia.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 10:15:08PM +0300, Stefan Becker wrote:
> Hi,
>
> ext Greg KH wrote:
>> Hm, isn't this also an issue in 2.6.25 as well?  I've had a few very
>> strange reports of USB just locking up in 2.6.25, could this also be the
>> cause there?
>
> As I wrote in the first mail of this thread the problem was uncovered on my 
> machine by the following commit from 2.6.24-development:
>
> commit e9df41c5c5899259541dc928872cad4d07b82076
> USB: make HCDs responsible for managing endpoint queues
>
> The interrupt problem exists also in 2.6.23 (and previous) but the USB code 
> was not affected, as the old versions of the functions were using 
> spin_lock_irqsave().
>
> I just applied my patch to 2.6.24 & 2.6.25: it applies fine and compiles 
> without problem. So it could be submitted to the 2.6.24.X and 2.6.25.X 
> branches too.

Thanks, I'll queue it up for there as well.

greg k-h
