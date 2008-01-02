Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbYABXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbYABXvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYABXv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:51:28 -0500
Received: from pool-71-245-101-243.ptldor.fios.verizon.net ([71.245.101.243]:52810
	"EHLO scooby.int.st.wgz.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbYABXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:51:27 -0500
From: "Brett T. Warden" <brett.warden@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brett T. Warden" <brett.warden@gmail.com>
Subject: [PATCH] bw-qcam: Rename parameter 'aggressive' to 'force_init'
Date: Wed,  2 Jan 2008 15:51:25 -0800
Message-Id: <1199317885-1625-2-git-send-email-brett.warden@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199317885-1625-1-git-send-email-brett.warden@gmail.com>
References: a372714f0712051031n31b933bfw6a5f9cb57b8cb5b8@mail.gmail.com
 <1199317885-1625-1-git-send-email-brett.warden@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed new parameter name to 'force_init' for clarity, as per feedback.

Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
---
 drivers/media/video/bw-qcam.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index b74a9cb..0322653 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -82,15 +82,15 @@ OTHER DEALINGS IN THE SOFTWARE.
 static unsigned int maxpoll=250;   /* Maximum busy-loop count for qcam I/O */
 static unsigned int yieldlines=4;  /* Yield after this many during capture */
 static int video_nr = -1;
-static unsigned int aggressive;		/* Whether to probe aggressively */
+static unsigned int force_init;		/* Whether to probe aggressively */
 
 module_param(maxpoll, int, 0);
 module_param(yieldlines, int, 0);
 module_param(video_nr, int, 0);
 
-/* Set aggressive=1 to avoid detection by polling status register and
+/* Set force_init=1 to avoid detection by polling status register and
  * immediately attempt to initialize qcam */
-module_param(aggressive, int, 0);
+module_param(force_init, int, 0);
 
 static inline int read_lpstatus(struct qcam_device *q)
 {
@@ -336,7 +336,7 @@ static int qc_detect(struct qcam_device *q)
 	int count = 0;
 	int i;
 
-	if (aggressive)
+	if (force_init)
 		return 1;
 
 	lastreg = reg = read_lpstatus(q) & 0xf0;
-- 
1.5.3.7

