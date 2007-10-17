Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXJQShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXJQShq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbXJQShX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:37:23 -0400
Received: from tanas.ca ([206.248.136.31]:53888 "EHLO mail.unchanged.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbXJQShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:37:22 -0400
X-Greylist: delayed 677 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 14:37:22 EDT
MIME-Version: 1.0
Date: Wed, 17 Oct 2007 14:26:04 -0400
From: Andrei Tanas <andrei@tanas.ca>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: Actually define =?UTF-8?Q?EFLG=5FIF=20used=20in=20commit=20a?=
 =?UTF-8?Q?d=36c=39=33=35c=34=39=36=33ee=35=35=37=37=32=31=30ba=34=37=34?=
 =?UTF-8?Q?=33=34c=37c=35=39aec=38=31fa?=
Message-ID: <31718b2c56ed2d9dc58ac11c00e86bdc@localhost>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually define EFLG_IF used in commit
ad6c935c4963ee5577210ba47434c7c59aec81fa

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index e974ace..ff00dc9 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -225,6 +225,7 @@ static u16 twobyte_table[256] = {
 /* EFLAGS bit definitions. */
 #define EFLG_OF (1<<11)
 #define EFLG_DF (1<<10)
+#define EFLG_IF (1<<9)
 #define EFLG_SF (1<<7)
 #define EFLG_ZF (1<<6)
 #define EFLG_AF (1<<4)


