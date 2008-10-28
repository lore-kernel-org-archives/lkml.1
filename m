Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYJ1GYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYJ1GYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYJ1GYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:24:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbYJ1GYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:24:30 -0400
Date: Mon, 27 Oct 2008 23:24:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Message-Id: <20081027232415.b96c6e22.akpm@linux-foundation.org>
In-Reply-To: <1225129201-4634-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081027182654.7495be2b@i1501.lan.towertech.it>
	<1225129201-4634-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 17:40:01 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> This adds support for the RTC provided by the Wolfson Microelectronics
> WM8350.
> 
> This driver was originally written by Graeme Gregory and Liam Girdwood,
> though it has been modified since then to update it to current mainline
> coding standards and for API completeness.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> This revision:
>  - Marks remove() with __devexit_p()
>  - Fixes grammar in MODULE_DESCRIPTION()
> 
> which should address all the feedback from Alessandro.

This version did this:

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

 - Marks remove() with __devexit_p()
 - Fixes grammar in MODULE_DESCRIPTION()

which should address all the feedback from Alessandro.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <linux@wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2 drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2
+++ a/drivers/rtc/rtc-wm8350.c
@@ -488,7 +488,7 @@ static int __devexit wm8350_rtc_remove(s
 
 static struct platform_driver wm8350_rtc_driver = {
 	.probe = wm8350_rtc_probe,
-	.remove = wm8350_rtc_remove,
+	.remove = __devexit_p(wm8350_rtc_remove),
 	.suspend = wm8350_rtc_suspend,
 	.resume = wm8350_rtc_resume,
 	.driver = {
@@ -509,6 +509,6 @@ static void __exit wm8350_rtc_exit(void)
 module_exit(wm8350_rtc_exit);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
-MODULE_DESCRIPTION("RTC driver WM8350");
+MODULE_DESCRIPTION("RTC driver for the WM8350");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:wm8350-rtc");
_


