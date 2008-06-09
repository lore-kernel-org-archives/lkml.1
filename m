Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYFIVkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYFIVkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYFIVkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:40:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbYFIVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:40:04 -0400
Date: Mon, 9 Jun 2008 14:39:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <20080609205916.GC21429@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org>
References: <200806091712.46869.oliver@neukum.org> <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org> <20080609195015.GA6601@suse.de> <20080609205916.GC21429@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jun 2008, Pavel Machek wrote:
> 
> I believe we should just revert the "CONFIG_USB_PERSIST force on"
> patch, and solve this properly in 2.6.27.

Why?

The code would _still_ be buggy with that revert in place. You have to 
enable CONFIG_USB_PERSIST just to get even the _possibility_ of the sane 
behavior. 

If there is a problem with usblp, it just needs to be fixed. 

		Linus
