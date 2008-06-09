Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYFIVwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYFIVwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYFIVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:52:26 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38486 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYFIVwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:52:23 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Date: Mon, 9 Jun 2008 23:52:40 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200806091712.46869.oliver@neukum.org> <20080609205916.GC21429@elf.ucw.cz> <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092352.41681.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Juni 2008 23:39:10 schrieb Linus Torvalds:
> 
> On Mon, 9 Jun 2008, Pavel Machek wrote:
> > 
> > I believe we should just revert the "CONFIG_USB_PERSIST force on"
> > patch, and solve this properly in 2.6.27.
> 
> Why?
> 
> The code would _still_ be buggy with that revert in place. You have to 
> enable CONFIG_USB_PERSIST just to get even the _possibility_ of the sane 
> behavior. 
> 
> If there is a problem with usblp, it just needs to be fixed. 

There's a problem with every driver that does not implement reset_resume().
That's the majority of drivers.

	Regards
		Oliver

