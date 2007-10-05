Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbXJEQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbXJEQTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbXJEQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:19:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62585 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbXJEQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:19:44 -0400
Date: Fri, 5 Oct 2007 09:18:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Luciano Rocha <strange@nsk.no-ip.org>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: [patch available] Re: lguest compilation problem in 2.6.23-rc9
Message-Id: <20071005091809.d11f8003.randy.dunlap@oracle.com>
In-Reply-To: <20071005152147.GA8160@bit.office.eurotux.com>
References: <20071005152147.GA8160@bit.office.eurotux.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007 16:21:47 +0100 Luciano Rocha wrote:

> 
> $ git describe
> v2.6.23-rc9
> 
> $ make
> ...
> BUILD   arch/i386/boot/bzImage
> Root device is (254, 3)
> Setup is 11496 bytes (padded to 11776 bytes).
> System is 1233 kB
> Kernel: arch/i386/boot/bzImage is ready  (#1)
> Building modules, stage 2.
>   MODPOST 282 modules
>   ERROR: "kasprintf" [drivers/lguest/lg.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Latest Linus' kernel tree:
> $ git describe
> v2.6.23-rc9-41-g804b3f9
> $ make oldconfig
> ...
> $ make
> BUILD   arch/i386/boot/bzImage
> Root device is (254, 3)
> Setup is 11496 bytes (padded to 11776 bytes).
> System is 1234 kB
> Kernel: arch/i386/boot/bzImage is ready  (#2)
>   Building modules, stage 2.
>   MODPOST 282 modules
> ERROR: "kasprintf" [drivers/lguest/lg.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Config follows.

Fixed by
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/move-kasprintfo-to-obj-y.patch

Need to merge now?


---
~Randy
