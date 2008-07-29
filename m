Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYG2CDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYG2CDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYG2CDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:03:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:18659 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYG2CDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w0HZfPmS5wKLox7kC+VSTIYT8868v+H4SYoo92jqjZEf/ZR7KGxBoLcfn8v0Rxdr4K
         upQAPmeuW5OtgsLwyrvduXtgoAgjK7OmOB1W4Ztq2jJ4UaRyu9yEBodw6pXmaEW5jJvN
         i6Tjg3tY2MK6WT3bkOFp6PDOrSZdxUYDcxdVo=
Date: Tue, 29 Jul 2008 06:03:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] proc tty: remove ->read_proc from isdn capi
Message-ID: <20080729020318.GH3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/isdn/capi/capi.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1331,12 +1331,6 @@ static void capinc_tty_send_xchar(struct tty_struct *tty, char ch)
 #endif
 }
 
-static int capinc_tty_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
-{
-	return 0;
-}
-
 static struct tty_driver *capinc_tty_driver;
 
 static const struct tty_operations capinc_ops = {
@@ -1358,7 +1352,6 @@ static const struct tty_operations capinc_ops = {
 	.flush_buffer = capinc_tty_flush_buffer,
 	.set_ldisc = capinc_tty_set_ldisc,
 	.send_xchar = capinc_tty_send_xchar,
-	.read_proc = capinc_tty_read_proc,
 };
 
 static int capinc_tty_init(void)
-- 
1.5.4.5


