Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYJEQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYJEQJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYJEQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:06:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54862 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756337AbYJEQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:06:41 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 15/76] uml: small cleanups and note bugs to be dealt with by
	uml authors...
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:06:41 +0100
Message-ID: <20081005160636.1997.14973.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

