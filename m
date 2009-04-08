Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbZDHLri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbZDHLri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764633AbZDHL13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:27:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51400 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764615AbZDHL1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:25 -0400
X-Sasl-enc: Usn7ThK9fbN3Bg2SBh8GAZ4TlvLX0eTbhDsHYKAPd28u 1239190043
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 24/56] mips: Remove void casts
Date: Wed,  8 Apr 2009 12:21:56 +0100
Message-Id: <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 arch/mips/boot/elf2ecoff.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/boot/elf2ecoff.c b/arch/mips/boot/elf2ecoff.c
index c5a7f30..0a4cbf0 100644
--- a/arch/mips/boot/elf2ecoff.c
+++ b/arch/mips/boot/elf2ecoff.c
@@ -136,7 +136,7 @@ static char *saveRead(int file, off_t offset, off_t len, char *name)
 		fprintf(stderr, "%s: fseek: %s\n", name, strerror(errno));
 		exit(1);
 	}
-	if (!(tmp = (char *) malloc(len))) {
+	if (!(tmp = malloc(len))) {
 		fprintf(stderr, "%s: Can't allocate %ld bytes.\n", name,
 			len);
 		exit(1);
-- 
1.5.4.3

