Return-Path: <linux-kernel-owner+w=401wt.eu-S935316AbZLQEiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316AbZLQEiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763968AbZLQEEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:13 -0500
Received: from kroah.org ([198.145.64.141]:55458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763290AbZLQEEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:48 2009
Message-Id: <20091217035648.630575367@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>, Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [044/151] V4L/DVB: Fix test in copy_reg_bits()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit c95a419a5604ec8a23cd73f61e9bb151e8cbe89b upstream.

The reg_pair2[j].reg was tested twice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/common/tuners/mxl5007t.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -196,7 +196,7 @@ static void copy_reg_bits(struct reg_pai
 	i = j = 0;
 
 	while (reg_pair1[i].reg || reg_pair1[i].val) {
-		while (reg_pair2[j].reg || reg_pair2[j].reg) {
+		while (reg_pair2[j].reg || reg_pair2[j].val) {
 			if (reg_pair1[i].reg != reg_pair2[j].reg) {
 				j++;
 				continue;


