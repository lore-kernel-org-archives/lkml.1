Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYIGASp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYIGASp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 20:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYIGASf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 20:18:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:3577 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYIGASe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 20:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sZFP1WVWFvJptUqiyteXZcvH7tTsz6xWL16UnUXlJqbcXgAz9iTaPlTthD1/OCRXhW
         HUS+k8Y5tAtAbKhD0V8v6LUA4h3OKi2OzCEP9TmFsfEsp1UIjOxjNDNxUQ3xlvo88O5L
         avhKyMOG0qfXyjUq6AltsTOvOIhORKDWpL1Ww=
Message-ID: <efa8e58e0809061718l537f72b9t4b4721d6b25f4d1a@mail.gmail.com>
Date: Sun, 7 Sep 2008 02:18:33 +0200
From: "=?UTF-8?Q?Rune_V._Sj=C3=B8en?=" <rvsjoen@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.27-rc5] Fix compilation warning "discards qualifiers from pointer target type" in io_32.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m870Iwdq009290

Fixes compilation warning "discards qualifiers from pointer targettype" in io_32.h
Signed-off-by: Rune V. SjÃ¸en <rvsjoen@gmail.com>---
--- a/include/asm-x86/io_32.h+++ b/include/asm-x86/io_32.h@@ -152,7 +152,7 @@ memcpy_fromio(void *dst, const void __iomem *src, int count) }
 static inline void-memcpy_toio(volatile void __iomem *dst, const void *src, int count)+memcpy_toio(void __iomem *dst, const void *src, int count) {        __memcpy((void __force *)dst, src, count); }
-- Rune V. SjÃ¸enYou always pass failure on the way to successÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
