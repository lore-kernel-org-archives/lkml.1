Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYGRWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYGRWiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYGRWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:38:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60783 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYGRWiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:38:13 -0400
Date: Fri, 18 Jul 2008 15:37:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pascal Terjan <pterjan@mandriva.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 8 (HID)
Message-Id: <20080718153732.d79f7d9f.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LNX.1.10.0807090954480.25171@jikos.suse.cz>
References: <20080708192251.3275d283.sfr@canb.auug.org.au>
	<20080708111649.e61b19bc.randy.dunlap@oracle.com>
	<alpine.LNX.1.10.0807090954480.25171@jikos.suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 09:59:24 +0200 (CEST) Jiri Kosina wrote:

> On Tue, 8 Jul 2008, Randy Dunlap wrote:
> 
> > drivers/built-in.o: In function `usb_kbd_probe':
> > usbkbd.c:(.text+0x1457c9): undefined reference to `usbhid_lookup_quirk'
> > drivers/built-in.o: In function `usb_mouse_probe':
> > usbmouse.c:(.text+0x14603c): undefined reference to `usbhid_lookup_quirk'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> 
> This got introduced by Jiri's
> 
>  	HID: fix quirk handling in usbmouse/kbd
> 
> Added to CC (and added also Pascal).
> 
> The dependency of usbkbd/usbmouse on usbhid is strange anyway. I'd 
> probably remove the whole quirk lookup thing from usbkbd/usbmouse drivers. 
> They introduce this ugly dependency, which is not worth it I guess. Also 
> usbkbd/usbmouse drivers are not needed in the vast majority of cases 
> anyway, and they shouldn't be loaded in standard configurations at all.

Build error still present in linux-next 20080718.
Please fix it in some manner.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
