Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbZABNYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbZABNYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbZABNYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:24:09 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:36140 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZABNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xEl94wFnGusuceNmceDtfPyqj4ZsNKb8DOTO1b7Vx3Vf78frS4X4pGYThect7BDDEm
         sBvS2gMXkri7yapkA65dC4tbgd174LY1cW39naqY9HkfNxKFQa3ITLZDyTMe/IyEqihD
         Gz5+0bHjPAuswSq6glN3XZdqqfoR4xo6xZUfQ=
Date: Fri, 2 Jan 2009 21:23:56 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090102132355.GA4833@thyme.bj.intel.com>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <Pine.LNX.4.44L0.0901011225400.32126-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0901011225400.32126-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 12:29:51PM -0500, Alan Stern wrote:
> On Fri, 2 Jan 2009, Yan Li wrote:
> > On it's manual read "you should unplug and remove the device only when
> > the light is off."
> 
> It's not clear whether you should believe this.  The manual may have 
> overstated things.  Still, better to be safe.

Yeah, that maybe true. Better to be safe. And we can't tell users just
to ignore the warnings on the manual.

> > On Windows and Mac OS, `safely remove this device' function effectly
> > turns it into `suspend' mode, and it's light off.
> 
> Yes -- but they don't suspend the device; instead they disable its 
> upstream port.  As far as the device is concerned, there's no 
> difference.  However the Linux API doesn't include any way to disable a 
> USB port.  Maybe we should add one...

Definitely.

> >  I did a
> > quick search in LKML and haven't found specific oppose to enable USB
> > suspend by default, and Debian has started shipping a kernel with
> > it turned on since 2.6.26.
> > 
> > Perhaps we should consider turning it on by default?  Thanks!
> 
> That is indeed the next step to take.

Hope to see this happen soon.

-- 
Li, Yan
