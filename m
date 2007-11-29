Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXK2Vyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXK2Vyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762810AbXK2Vyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:54:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbXK2Vyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:54:40 -0500
Date: Thu, 29 Nov 2007 13:17:31 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
	insert/remove race (v3)
Message-ID: <20071129211731.GA11629@suse.de>
References: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org> <474F1AAC.7040908@rtr.ca> <20071129201224.GA25356@suse.de> <474F1DB3.4030900@rtr.ca> <474F2020.7020004@rtr.ca> <20071129203225.GA5383@suse.de> <474F2532.5090708@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F2532.5090708@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:46:42PM -0500, Mark Lord wrote:
> Greg KH wrote:
>> So again, the problem is in the higher up scsi layer, and that is where
>> the problem should already be fixed.
> ..
>
> Ahhh.. so you figure the Oops should also have been fixed
> as part of the 2.6.24 SCSI fixes ?  That's what I was missing here.

Yes, that is what Alan originally stated...
