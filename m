Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYLBDOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYLBDOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYLBDOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:14:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32812 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYLBDOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:14:35 -0500
Date: Tue, 2 Dec 2008 12:13:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-12-01-17-37 uploaded
Message-Id: <20081202121343.d95d1d59.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200812020138.mB21c64Y025671@imap1.linux-foundation.org>
References: <200812020138.mB21c64Y025671@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 17:38:06 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-12-01-17-37 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc6:
> 

> lis3lv02d-merge-with-leds-hp-disk.patch
This Hunks at drivers/leds/Makefile

@@ -23,7 +23,6 @@ obj-$(CONFIG_LEDS_HP6XX)              += leds-hp6xx.
 obj-$(CONFIG_LEDS_FSG)                 += leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)             += leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)              += leds-da903x.o
-obj-$(CONFIG_LEDS_HP_DISK)             += leds-hp-disk.o
 obj-$(CONFIG_LEDS_WM8350)              += leds-wm8350.o         <==========(*)

Removing (*) is enough. (maybe)

Thanks,
-Kame

