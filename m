Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbXJFCIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbXJFCIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 22:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXJFCIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 22:08:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:49723 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXJFCIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 22:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=lRvjw4hPF3+yBW69L6UNAdLRFxh6kF+kXfLkLCWtOpRYmk4FlAl7BzWRwcWq7WDkhgBlkAP7Zhu/ZzGLangxAochrrtMSH/AFRqNkVBcYrvFLtCGT9vwqZZZJgVOFpFSKADJVQ8SLtkhjfoGvbvhsKu/tatUsCgcz69fnOjydN0=
Date: Sat, 6 Oct 2007 10:02:29 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@osdl.org>, spi-devel-general@lists.sourceforge.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [Patch]Documentation/spi/spidev_test.c: constify some variables
Message-ID: <20071006020229.GB2436@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Constify two char pointers and a struct in Documentation/spi/spidev_test.c.

CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 Documentation/spi/spidev_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.23-rc9/Documentation/spi/spidev_test.c
===================================================================
--- linux-2.6.23-rc9.orig/Documentation/spi/spidev_test.c
+++ linux-2.6.23-rc9/Documentation/spi/spidev_test.c
@@ -29,7 +29,7 @@ static void pabort(const char *s)
 	abort();
 }
 
-static char *device = "/dev/spidev1.1";
+static const char *device = "/dev/spidev1.1";
 static uint8_t mode;
 static uint8_t bits = 8;
 static uint32_t speed = 500000;
@@ -69,7 +69,7 @@ static void transfer(int fd)
 	puts("");
 }
 
-void print_usage(char *prog)
+void print_usage(const char *prog)
 {
 	printf("Usage: %s [-DsbdlHOLC3]\n", prog);
 	puts("  -D --device   device to use (default /dev/spidev1.1)\n"
@@ -88,7 +88,7 @@ void print_usage(char *prog)
 void parse_opts(int argc, char *argv[])
 {
 	while (1) {
-		static struct option lopts[] = {
+		static const struct option lopts[] = {
 			{ "device",  1, 0, 'D' },
 			{ "speed",   1, 0, 's' },
 			{ "delay",   1, 0, 'd' },
