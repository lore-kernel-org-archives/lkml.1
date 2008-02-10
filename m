Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbYBJDIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbYBJDIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYBJDIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:08:11 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:60723 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755297AbYBJDIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:08:10 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Silent compiler warning introduced by 11b0cc3a4af65413ca3bb5698769e091486e0b22 (x25_asy: Fix ref count rule violation)
Date: Sun, 10 Feb 2008 05:06:25 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: alan@redhat.com, davem@davemloft.net, khc@pm.waw.pl, jeff@garzik.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802100506.28910.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch silents
 
drivers/net/wan/x25_asy.c: In function `x25_asy_open_tty':
drivers/net/wan/x25_asy.c:557: warning: unused variable `ld'

compiler warning introduced by commit 11b0cc3a4af65413ca3bb5698769e091486e0b22 (x25_asy: Fix ref count rule violation)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 drivers/net/wan/x25_asy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 5e2d763..0f8aca8 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -554,7 +554,6 @@ static void x25_asy_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 static int x25_asy_open_tty(struct tty_struct *tty)
 {
 	struct x25_asy *sl = (struct x25_asy *) tty->disc_data;
-	struct tty_ldisc *ld;
 	int err;
 
 	/* First make sure we're not already connected. */

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
