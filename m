Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbXC3VMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbXC3VMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXC3VMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbXC3VLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:25 -0400
Date: Fri, 30 Mar 2007 14:05:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 22/37] V4L: Fix SECAM handling on saa7115
Message-ID: <20070330210557.GY29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-fix-secam-handling-on-saa7115.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@infradead.org>

V4L: Fix SECAM handling on saa7115

(cherry picked from commit a9aaec4e83e687d23b78b38e331bbd6a10b96380)

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7115.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -960,7 +960,7 @@ static void saa711x_set_v4lstd(struct i2
 			reg |= 0x10;
 		} else if (std == V4L2_STD_NTSC_M_JP) {
 			reg |= 0x40;
-		} else if (std == V4L2_STD_SECAM) {
+		} else if (std & V4L2_STD_SECAM) {
 			reg |= 0x50;
 		}
 		saa711x_write(client, R_0E_CHROMA_CNTL_1, reg);

-- 
