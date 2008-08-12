Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbYHLXKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbYHLXKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYHLXJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:09:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYHLXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:09:52 -0400
Date: Tue, 12 Aug 2008 16:09:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <JosephChan@via.com.tw>
Cc: JosephChan@via.com.tw, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH 1/13 v3] viafb: fix for the description of the VX800 2D
 acceleration issue in viafb.txt.
Message-Id: <20080812160934.9371732e.akpm@linux-foundation.org>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F4A00@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F4A00@exchtp03.taipei.via.com.tw>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 08:53:47 +0800
<JosephChan@via.com.tw> wrote:

> Correct the description of VX800 2D acceleration, the driver diables the acceleration
> function by defualt if you use VX800 chip.
> Correct via_fb_ to viafb_ and remove the Kconfig part in viafb.txt.

The difference betwee this patch and the previous one
(viafb-viafbmodes-viafbtxt.patch) is:

--- a/Documentation/fb/viafb.txt~viafb-viafbmodes-viafbtxt-fix
+++ a/Documentation/fb/viafb.txt
@@ -182,8 +182,9 @@ Notes:
        instead of calling common ioctl function FBIOPUT_VSCREENINFO since
        viafb doesn't support multi-head well, or it will cause screen crush.
     4. VX800 2D accelerator hasn't been supported in this driver yet. When
-       using driver on VX800, one should add parameter "viafb_accel=0" to
-       disable 2D accelerator.
+       using driver on VX800, the driver will disable the acceleration funciton.
+       as default.
+
 
 [Configure viafb with "fbset" tool]
 -----------------------------------
_

Which does not fully meet your description of it?

I'll fix the "funciton" spelling.
