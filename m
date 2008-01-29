Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbYA2TWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbYA2TWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYA2TVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:21:49 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45186 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765549AbYA2TVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:21:45 -0500
Date: Tue, 29 Jan 2008 20:21:44 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: Add support for DIF CRC
In-Reply-To: <yq1prvk8p3f.fsf@sermon.lab.mkp.net>
Message-ID: <Pine.LNX.4.64.0801292020010.14907@fbirervta.pbzchgretzou.qr>
References: <yq1prvk8p3f.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2008 13:27, Martin K. Petersen wrote:
>--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
>+++ b/include/linux/crc-t10dif.h	Tue Jan 29 13:26:19 2008 -0500
>@@ -0,0 +1,9 @@
>+#ifndef _LINUX_CRC_T10DIF_H
>+#define _LINUX_CRC_T10DIF_H
>+
>+#include <linux/types.h>
>+
>+const __u16 t10_dif_crc_table[256];
>+__u16 crc_t10dif(unsigned char const *, size_t);
                  'const unsigned char *', like the
rest of all code does.

>+++ b/lib/crc-t10dif.c	Tue Jan 29 13:26:19 2008 -0500

Do we already have some users for the T10DIF CRC?
