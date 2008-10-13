Return-Path: <linux-kernel-owner+w=401wt.eu-S1762728AbYJMJn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728AbYJMJn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760742AbYJMJgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:36:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48628 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756569AbYJMJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:36:52 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 31/80] uml: small cleanups and note bugs to be dealt with by
	uml authors...
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:36:49 +0100
Message-ID: <20081013093645.21645.87767.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
---

 arch/um/drivers/line.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index d741f35..14a102e 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -275,6 +275,8 @@ int line_ioctl(struct tty_struct *tty, struct file * file,
 	case TIOCGLTC:
 	case TIOCSLTC:
 #endif
+	/* Note: these are out of date as we now have TCGETS2 etc but this
+	   whole lot should probably go away */
 	case TCGETS:
 	case TCSETSF:
 	case TCSETSW:

