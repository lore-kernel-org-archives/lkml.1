Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZAMGEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZAMGEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZAMGDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:03:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39378 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZAMGDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:03:51 -0500
Date: Tue, 13 Jan 2009 15:02:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, andrew@sanpeople.com,
       ben@simtec.co.uk, dbrownell@users.sourceforge.net, dsaxena@plexity.net,
       gl@dsa-ac.de, iwamatsu@nigauri.org, kyle@mcmartin.ca,
       lethal@linux-sh.org, pmironchik@optifacio.net, raph@raphnet.net,
       rongkai.zhan@windriver.com, rpurdie@rpsys.net, scottwood@freescale.com,
       yoichi_yuasa@tripeaks.co.jp
Subject: Re: + rtc-cumulative-style-fixes-fix.patch added to -mm tree
Message-Id: <20090113150242.e2f4a243.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200901130315.n0D3FdSW015473@imap1.linux-foundation.org>
References: <200901130315.n0D3FdSW015473@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 19:15:39 -0800
akpm@linux-foundation.org wrote:

> 
> The patch titled
>      rtc-cumulative-style-fixes-fix
> has been added to the -mm tree.  Its filename is
>      rtc-cumulative-style-fixes-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
This additional one was necessary for me.
But not sure this is the best "include" target.
-Kame

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This was necessary for hpet* functions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 drivers/rtc/rtc-cmos.c |    1 +
 1 file changed, 1 insertion(+)

Index: mmotm-2.6.28-Jan12/drivers/rtc/rtc-cmos.c
===================================================================
--- mmotm-2.6.28-Jan12.orig/drivers/rtc/rtc-cmos.c
+++ mmotm-2.6.28-Jan12/drivers/rtc/rtc-cmos.c
@@ -39,6 +39,7 @@
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
+#include <asm/hpet.h>
 
 struct cmos_rtc {
 	struct rtc_device	*rtc;



