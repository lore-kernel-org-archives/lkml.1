Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXJJXwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXJJXwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXJJXwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:52:07 -0400
Received: from zap.org.AU ([129.94.172.224]:37599 "EHLO mail.zap.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbXJJXwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:52:06 -0400
Date: Thu, 11 Oct 2007 09:52:01 +1000
From: John Zaitseff <J.Zaitseff@zap.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Key codes for Microsoft Natural Ergonomic 4000 USB keyboard
Message-ID: <20071010235201.GA12338@zap.org.au>
References: <20071010055958.GA25938@zap.org.au> <Pine.LNX.4.64.0710100953050.20620@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710100953050.20620@jikos.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jiri,

On Wed, Oct 10, 2007 at 09:55:26AM +0200, Jiri Kosina wrote:
> On Wed, 10 Oct 2007, John Zaitseff wrote:
> 
> > The following patch to Linux kernel 2.6.23 enables most of the
> > extra keys found on the Microsoft Natural Ergonomic 4000 USB
> > keyboard.  I had to add one keycode to include/linux/input.h;
> > feel free to reallocate the ID assigned to it (KEY_SPELL).
> 
> thanks a lot for the patch!  However I think I have already added
> all the needed support for this keyboard.  It is currently in my
> tree, queued until Linus opens the merge window for 2.6.24.
> Please look at
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=0f48b3ce23a34dbe70dcd04b4216fbcb965ab906
> 
> Commit 945bcc3a in the same branch is also related.

Excellent!  However, I don't see the following:

* case 0x182: map_key_clear(KEY_FAVORITES);
  ... in drivers/usb/input/hid-input.c, to handle the My Favorites key

* the change to drivers/hid/usbhid/usbkbd.c to enable the "(" and
  ")" on the right hand side of the keyboard

Have these already been included elsewhere?

Yours truly,

John Zaitseff

-- 
John Zaitseff                    ,--_|\    The ZAP Group
Phone:  +61 2 9643 7737         /      \   Sydney, Australia
E-mail: J.Zaitseff@zap.org.au   \_,--._*   http://www.zap.org.au/
                                      v
