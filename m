Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYCVAGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYCVAGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 20:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYCVAGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 20:06:31 -0400
Received: from igraine.blacknight.ie ([81.17.252.25]:37614 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYCVAGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 20:06:30 -0400
Date: Sat, 22 Mar 2008 00:05:57 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Robert Fitzsimons <robfitz@273k.net>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] bttv: Add a radio compat_ioctl file operation.
Message-ID: <20080322000557.GA21314@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za> <200803172351.56717.bonganilinux@mweb.co.za> <20080320142212.2361f6d8@gaivota> <200803211655.31085.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803211655.31085.bonganilinux@mweb.co.za>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 1JcrF6-0002jc-6Z
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=1.608, required 7,
	autolearn=disabled, HELO_LOCALHOST 4.50, RCVD_IN_NERDS_IE -3.50,
	RCVD_IN_PBL 0.51, RDNS_NONE 0.10)
X-blacknight-igraine-MailScanner-SpamScore: s
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


Hi Bongani

I only noticed that you might be using a 32 bit userspace, so the radio
compat_ioctl needs to be implmented.

Robert



diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5404fcc..1bdb726 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3601,6 +3601,7 @@ static const struct file_operations radio_fops =
 	.read     = radio_read,
 	.release  = radio_release,
 	.ioctl	  = video_ioctl2,
+	.compat_ioctl	= v4l_compat_ioctl32,
 	.llseek	  = no_llseek,
 	.poll     = radio_poll,
 };
-- 
1.5.4.3.484.g60e3

