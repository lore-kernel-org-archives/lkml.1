Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXJKHLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXJKHLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXJKHLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:11:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:54302 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755730AbXJKHLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:11:18 -0400
Date: Thu, 11 Oct 2007 09:11:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: John Zaitseff <J.Zaitseff@zap.org.au>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Key codes for Microsoft Natural Ergonomic 4000 USB
 keyboard
In-Reply-To: <20071010235201.GA12338@zap.org.au>
Message-ID: <Pine.LNX.4.64.0710110909020.20620@jikos.suse.cz>
References: <20071010055958.GA25938@zap.org.au> <Pine.LNX.4.64.0710100953050.20620@jikos.suse.cz>
 <20071010235201.GA12338@zap.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, John Zaitseff wrote:

> Excellent!  However, I don't see the following:
> * case 0x182: map_key_clear(KEY_FAVORITES);
>   ... in drivers/usb/input/hid-input.c, to handle the My Favorites key

There is also a patch queued on top of the patchset you were looking at, 
which adds support for Natural Ergonomic 6000 Keyboard, which also 
establishes the mapping of 0x182 to KEY_BOOKMARKS.

> * the change to drivers/hid/usbhid/usbkbd.c to enable the "(" and
>   ")" on the right hand side of the keyboard

usbkbd.c is not used under normal circumstances (it uses the hid boot 
protocol), I don't think it is needed to care too much for updating the 
keymap there.

Thanks,

-- 
Jiri Kosina
SUSE Labs
