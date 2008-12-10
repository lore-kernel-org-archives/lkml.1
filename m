Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYLJNwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYLJNwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYLJNwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:52:01 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:60006 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYLJNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:51:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent:from;
        b=QQXXpp/3M954+qxJYvSPL4mw7qDl40hTo8J4qMJtDDH/Zg3HMeXMDua4DnGeK+WA1F
         3Z8xe1uMADQPNDWRIZTPaPKhVGN0uGofvrqebTe5oha9quNFIS/kwxmH7APO8CYsVROq
         oRBxCZf3ZDMUSo9xJtC2KWd+LqUdWJ2cvPCuY=
Date: Wed, 10 Dec 2008 21:51:43 +0800
To: linux-kernel@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk
Subject: [PATCH] fix some code style that line over 80 characters
Message-ID: <20081210135143.GB4595@helight>
Reply-To: "Helight.Xu" <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "Helight.Xu" <zhwenxu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 449a3ddd01a98aae9122d5199083f45ab9c98469 Mon Sep 17 00:00:00 2001
From: Zhwen Xu <Helight.Xu@gmail.com>
Date: Wed, 10 Dec 2008 21:29:04 +0800
Subject: [PATCH] fix some code style that line over 80 characters 

Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index c772e02..c466870 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -109,7 +109,8 @@ static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c *i2c)
  * the default if there is none
 */
 
-static inline struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
+static inline struct
+s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
 {
 	if (dev->platform_data != NULL)
 		return (struct s3c2410_platform_i2c *)dev->platform_data;
@@ -123,7 +124,8 @@ static inline struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct d
  * or zero to mean ok.
 */
 
-static inline void s3c24xx_i2c_master_complete(struct s3c24xx_i2c *i2c, int ret)
+static inline void
+s3c24xx_i2c_master_complete(struct s3c24xx_i2c *i2c, int ret)
 {
 	dev_dbg(i2c->dev, "master_complete %d\n", ret);
 
@@ -273,7 +275,8 @@ static inline int is_msgend(struct s3c24xx_i2c *i2c)
  * process an interrupt and work out what to do
  */
 
-static int i2s_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c, unsigned long iicstat)
+static int i2s_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c,
+				unsigned long iicstat)
 {
 	unsigned long tmp;
 	unsigned char byte;
@@ -502,7 +505,8 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c *i2c)
  * this starts an i2c transfer
 */
 
-static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c, struct i2c_msg *msgs, int num)
+static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
+			 struct i2c_msg *msgs, int num)
 {
 	unsigned long timeout;
 	int ret;
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
