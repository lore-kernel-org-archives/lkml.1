Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYGGFJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYGGFJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 01:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYGGFJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 01:09:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:17716 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYGGFJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 01:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=anuBzEE3oRhuDq2cLIZIRsDikTPCHvPzudM/Pe9OI62klbXmJWN19E51980WAujrEo
         jxmgFhqOLnvIlmnPp5Ts8v+eHdxgw7Xbjy99UHqotnlwZg8v+adQnEJAG7cJOsi+qKi8
         ag9XtGJ+LW5yXp35KwX4E4GrZ/+QPjRPRbFLE=
From: Denis Cheng <crquan@gmail.com>
To: Heikki Orsila <heikki.orsila@iki.fi>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] more "suport -> support" typo fix from git grep
Date: Mon,  7 Jul 2008 13:08:31 +0800
Message-Id: <1215407311-12122-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.6.GIT
In-Reply-To: <20080706212858.GB8025@uranus.ravnborg.org>
References: <20080706212858.GB8025@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    $ git grep -w -i -n suport
    Documentation/video4linux/bttv/Sound-FAQ:85:Another one with bt878 suport is available from
    drivers/media/video/uvc/uvc_video.c:861:        /* Some webcams don't suport GET_DEF request on the probe control. We
    drivers/net/wireless/ath5k/ath5k.h:223: * channels. To use this feature your Access Point must also suport it.
    net/ipv4/tcp_cong.c:4: * Based on ideas from I/O scheduler suport and Web100.
    net/sctp/sm_statefuns.c:3793:   /* Make sure that we suport the HMAC algorithm from the auth

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
To Heikki and typo-fix patches authors:
    Anytime intend to make a typo-fix patch, you'd better do a `git-grep` first,
    that would fix all this typo in the whole tree one time. thanks.

 Documentation/video4linux/bttv/Sound-FAQ |    2 +-
 drivers/media/video/uvc/uvc_video.c      |    2 +-
 drivers/net/wireless/ath5k/ath5k.h       |    2 +-
 net/ipv4/tcp_cong.c                      |    2 +-
 net/sctp/sm_statefuns.c                  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/video4linux/bttv/Sound-FAQ b/Documentation/video4linux/bttv/Sound-FAQ
index 1e6328f..daa8935 100644
--- a/Documentation/video4linux/bttv/Sound-FAQ
+++ b/Documentation/video4linux/bttv/Sound-FAQ
@@ -82,7 +82,7 @@ card installed, you might to check out if you can read these registers
 values used by the windows driver.  A tool to do this is available
 from ftp://telepresence.dmem.strath.ac.uk/pub/bt848/winutil, but it
 does'nt work with bt878 boards according to some reports I received.
-Another one with bt878 suport is available from
+Another one with bt878 support is available from
 http://btwincap.sourceforge.net/Files/btspy2.00.zip
 
 You might also dig around in the *.ini files of the Windows applications.
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 6faf1fb..2eae8c5 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -858,7 +858,7 @@ int uvc_video_init(struct uvc_video_device *video)
 	 */
 	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
 
-	/* Some webcams don't suport GET_DEF request on the probe control. We
+	/* Some webcams don't support GET_DEF request on the probe control. We
 	 * fall back to GET_CUR if GET_DEF fails.
 	 */
 	if ((ret = uvc_get_video_ctrl(video, probe, 1, GET_DEF)) < 0 &&
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index ba35c30..dafc7e7 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -220,7 +220,7 @@ struct ath5k_srev_name {
  * Modulation for Atheros' Turbo G and Turbo A, its supposed to provide a
  * throughput transmission speed up to 40Mbit/s-60Mbit/s at a 108Mbit/s
  * signaling rate achieved through the bonding of two 54Mbit/s 802.11g
- * channels. To use this feature your Access Point must also suport it.
+ * channels. To use this feature your Access Point must also support it.
  * There is also a distinction between "static" and "dynamic" turbo modes:
  *
  * - Static: is the dumb version: devices set to this mode stick to it until
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 6a25082..6da9aae 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -1,7 +1,7 @@
 /*
  * Plugable TCP congestion control support and newReno
  * congestion control.
- * Based on ideas from I/O scheduler suport and Web100.
+ * Based on ideas from I/O scheduler support and Web100.
  *
  * Copyright (C) 2005 Stephen Hemminger <shemminger@osdl.org>
  */
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 0c9d5a6..89399f9 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3790,7 +3790,7 @@ static sctp_ierror_t sctp_sf_authenticate(const struct sctp_endpoint *ep,
 	chunk->subh.auth_hdr = auth_hdr;
 	skb_pull(chunk->skb, sizeof(struct sctp_authhdr));
 
-	/* Make sure that we suport the HMAC algorithm from the auth
+	/* Make sure that we support the HMAC algorithm from the auth
 	 * chunk.
 	 */
 	if (!sctp_auth_asoc_verify_hmac_id(asoc, auth_hdr->hmac_id))
-- 
1.5.6.GIT

