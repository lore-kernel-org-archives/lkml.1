Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYFAWMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYFAWMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYFAWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:11:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55635 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbYFAWLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:11:54 -0400
Date: Sun, 1 Jun 2008 23:11:53 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: =?iso-8859-15?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock
 held
In-Reply-To: <1212358046.6296.12.camel@odie.local>
Message-ID: <alpine.DEB.0.82.0806012310440.5760@skynet.skynet.ie>
References: <1212347789.2580.9.camel@odie.local> 
 <alpine.DEB.0.82.0806012218560.5760@skynet.skynet.ie>
 <1212358046.6296.12.camel@odie.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Backtrace:
> 0: X(xf86SigHandler+0x80) [0x80d29f0]
> 1: [0xb7f54400]
> 2: /usr/lib/xorg/modules/input//evdev_drv.so [0xb7aab90e]
> 3: X [0x80d2b87]
> 4: X [0x80b6065]
> 5: [0xb7f54400]
> 6: X(Dispatch+0x81) [0x808d5d1]
> 7: X(main+0x485) [0x8074bb5]
> 8: /lib/libc.so.6(__libc_start_main+0xdc) [0xb7c813ec]
> 9: X(FontFileCompleteXLFD+0x229) [0x8073f21]
> 
> Fatal server error:
> Caught signal 11.  Server aborting

Looks like X is dying in its input driver, which is causing the video 
driver to do something without the lock, so its an X.org configuration or 
build issues.. best ask on xorg@lists.freedesktop.org

Dave.
