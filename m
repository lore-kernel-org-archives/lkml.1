Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbYBMU4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbYBMU4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYBMU4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:56:44 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:30953 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbYBMU4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:56:43 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 13 Feb 2008 20:55:00 +0000
Message-Id: <d77926ee726c95d53e0ce1b7ab83d6e166758ef1.1202935389.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <f23109fa609b27625e7650299684cde3b85d3815.1202935389.git.ijc@hellion.org.uk>
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
 <f23109fa609b27625e7650299684cde3b85d3815.1202935389.git.ijc@hellion.org.uk>
In-Reply-To: <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
References: <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv3 3/3] x86: bump image header to version 2.08.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=s3JV9krLTsEA:10 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=C8KwMXAS5yLQci8bX0wA:9 a=zVA5SYDnbsP6MjZWM09dQnt-f0wA:4 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=JcB9aHnUDh0A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/header.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8471658..40c91bb 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -120,7 +120,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0207		# header version number (>= 0x0105)
+		.word	0x0208		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
-- 
1.5.4

