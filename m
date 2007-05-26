Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbXEZQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbXEZQqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXEZQq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:46:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:46822 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753366AbXEZQq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:46:27 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX1+XhOdjdFyX0CxA+Eft35cAjkWSjNT46I2m0IOTH8
	rznXRdJKoZ6D96
Date: Sat, 26 May 2007 18:46:22 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [BUG] Warning in mm/slab.c:777
Message-Id: <20070526184622.cfdba54a.delist@gmx.net>
In-Reply-To: <200705260849.00356.eike-kernel@sf-tec.de>
References: <200705260849.00356.eike-kernel@sf-tec.de>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also sprach Rolf Eike Beer <eike-kernel@sf-tec.de> (Sat, 26 May 2007 08:48:55 +0200):
> After bootup (runlevel 5) I found this in dmesg:
> 
> WARNING: at mm/slab.c:777 __find_general_cachep()
>  [<c0165fe1>] __kmalloc+0x40/0xc3
>  [<f8f4d5ed>] drm_rmdraw+0x126/0x24e [drm]
>  [<c023e68b>] skb_dequeue+0x39/0x3f
>  [<f8f4d4c7>] drm_rmdraw+0x0/0x24e [drm]
>  [<f8f4e10e>] drm_ioctl+0x14c/0x192 [drm]
>  [<c0172cb0>] do_ioctl+0x4c/0x62
>  [<c0172efd>] vfs_ioctl+0x237/0x249
>  [<c017aff3>] mntput_no_expire+0x11/0x68
>  [<c0172f5b>] sys_ioctl+0x4c/0x65
>  [<c0103cde>] sysenter_past_esp+0x5f/0x85
>  =======================
> 
> Kernel is Linus' git of yesterday, the first occurence of this in my logs was 
> on May 16th.

It may be the same zero request I hit in slub, and according to 
http://bugzilla.kernel.org/show_bug.cgi?id=8476 people care about. Also
I remember a mail from Linus, where he meant it's handled quite well
(currently no link cause fetching thze whole IMAP quite takes some
time, sry).

> Greetings,
> 
> Eike

sl, ritch
