Return-Path: <linux-kernel-owner+w=401wt.eu-S1764309AbYEBTJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764309AbYEBTJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965052AbYEBTFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965033AbYEBTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ft2MGUzkqMEFYU6gveQEU+AcEVGAkN5QCb+PWhqDC1rnC7eRJZOU17bBqs+9AqctszmUHRBZEtA+CaYEGSpAX5PLvHTIT8iVvHZhOSoTW9QotVp8MilSpq4CCUYKLjFlkKrFR7M0YCxAIrkXaAWosRAjy45xIa2M/yHrOoTP6Fc=
Subject: [PATCH 05/14] usb: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:56 -0700
Message-Id: <1209755156.26173.71.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/serial/kl5kusb105.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index f328948..79787ed 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -236,7 +236,7 @@ static int klsi_105_get_line_state(struct usb_serial_port *port,
 	if (rc < 0)
 		err("Reading line status failed (error = %d)", rc);
 	else {
-		status = le16_to_cpu(get_unaligned((__le16 *)status_buf));
+		status = get_unaligned_le16(status_buf);
 
 		info("%s - read status %x %x", __func__,
 		     status_buf[0], status_buf[1]);
-- 
1.5.5.1.350.gbbbf


