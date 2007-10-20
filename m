Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXJTGDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXJTGDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXJTGDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:03:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXJTGDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:03:37 -0400
Date: Fri, 19 Oct 2007 22:59:47 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Larry Finger <larry.finger@lwfinger.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] Locking problem in usbserial with 2.6.23-git
	5a34417f
Message-ID: <20071020055947.GA12130@kroah.com>
References: <4718D469.2080606@lwfinger.net> <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz> <4719235E.9030507@lwfinger.net> <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 12:05:19AM +0200, Jiri Kosina wrote:
> On Fri, 19 Oct 2007, Larry Finger wrote:
> 
> > As I said earlier, the lock problem went away; however, I get the 
> > following two kernel warnings:
> 
> That's because I messed up the patch, sorry. The one below should work 
> better.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> USB: usbserial - fix potential deadlock between write() and IRQ

Jiri, thanks a lot for the fix, I'll queue it up.

greg k-h
