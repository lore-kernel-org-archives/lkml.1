Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbYF2Nx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbYF2Nx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYF2Nxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:53:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:14230 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbYF2Nxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=k7UtrhIyWTlXjLOzH2VpCSn+GfFLAcMHAr4ojbHFsYTZuvfe+cbsyvZUazIS0cVtDR
         beHJ6isjr5zGAYQiMJMI1qPzPNw8ORpd42Y34dpQpAEwUMeOjcNa3bpdnDvxQNC5v8PU
         sUQgMxWEeYhM3s6W5sw4qyim+6gf/J6kh2Ab4=
Subject: [PATCH] w100fb: add 80 MHz modeline
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alberto Mardegan <mardy@users.sourceforge.net>, Ian Molton <spyro@f2s.com>,
       Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 15:53:47 +0200
Message-Id: <1214747627.2758.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for HTC Blueangel (w3200).
At 96MHz its screen flickers.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/video/w100fb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 30469bf..3e48eef 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -1003,6 +1003,7 @@ static struct w100_pll_info xtal_14318000[] = {
 static struct w100_pll_info xtal_16000000[] = {
 	/*freq     M   N_int    N_fac  tfgoal  lock_time */
 	{ 72,      1,   8,       0,     0xe0,        48}, /* tfgoal guessed */
+	{ 80,      1,   9,       0,     0xe0,        13}, /* tfgoal guessed */
 	{ 95,      1,   10,      7,     0xe0,        38}, /* tfgoal guessed */
 	{ 96,      1,   11,      0,     0xe0,        36}, /* tfgoal guessed */
 	{  0,      0,   0,       0,        0,         0},
-- 
1.5.5.4


