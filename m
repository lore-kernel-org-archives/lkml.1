Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYEFEyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYEFEyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYEFEyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:54:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYEFEyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:54:43 -0400
Date: Mon, 5 May 2008 21:48:46 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-ID: <20080506044846.GE4773@kroah.com>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503154542.18807e59.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 03:45:42PM +1000, Stephen Rothwell wrote:
> I currently have 54 trees that (I assume) are of type 2 above:
> 
> driver-core	usb

Internally I have both of these trees split into "current" and "next"
sections, so that I know what to merge when.

If it would make things easier for you, I'd be glad to split both of
these trees up in such a manner to make it more visable.

Perhaps:
	driver-core-next
	usb-next
	driver-core
	usb

would be sufficient for you?

> And three trees that I am not sure about:
> 
> x86-latest	sched-latest	ldp

ldp you have properly named as something that will probably go into
next-next or most likely next-next-next, but does build and run properly
today, yet has work to go in the "must clean up this crap" arena.

thanks,

greg k-h
