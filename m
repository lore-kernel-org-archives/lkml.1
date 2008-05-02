Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbYEBDym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbYEBDym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbYEBDwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:62619 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbYEBDwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tcKk2wRGVxXNahNRRTs05U0AvmLPFtGANDx+lyVjIGIdwznoa1bCSkNK65Z2fmU2UyBgT94lZZI35JB3dhbvV3YLrUp3ko0Spnhc2tmz+lRSbGnNcPiq7nOIHDwnFC3y/uLt7p6SUH4Sv4UEBK/jnYxiE+GM+xeloJ96NA5OsNc=
Subject: [PATCH 5/8] usb: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:57 -0700
Message-Id: <1209700377.22362.20.camel@brick>
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


