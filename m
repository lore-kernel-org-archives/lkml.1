Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270Ab0ATAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0ATAmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735Ab0ATAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:42:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45660 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0ATAmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nWK2QF6zcUNxtLDyendNpbz7X9x3Mzocttpe35oyROSogefWUs8YmskUeTdDjckkBX
         LT/M+aErgQHYyvDKtAwjS/trfJVxN9tG1m4plEFahG0e2mJVZeoP1xop4TPwzbTnTkNg
         MkV2eJqc8zNdpFLGOkc5oLirHylMDd/dJBhzQ=
Message-ID: <4B5652A2.8060500@gmail.com>
Date: Wed, 20 Jan 2010 01:47:30 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cx23885: Wrong command printed in cmd_to_str()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong command was printed for case CX2341X_ENC_SET_DNR_FILTER_MODE,
and a typo in case CX2341X_ENC_SET_PCR_ID.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or is this intended?

diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 88c0d24..2ab97ad 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -681,7 +681,7 @@ static char *cmd_to_str(int cmd)
 	case CX2341X_ENC_SET_VIDEO_ID:
 		return  "SET_VIDEO_ID";
 	case CX2341X_ENC_SET_PCR_ID:
-		return  "SET_PCR_PID";
+		return  "SET_PCR_ID";
 	case CX2341X_ENC_SET_FRAME_RATE:
 		return  "SET_FRAME_RATE";
 	case CX2341X_ENC_SET_FRAME_SIZE:
@@ -693,7 +693,7 @@ static char *cmd_to_str(int cmd)
 	case CX2341X_ENC_SET_ASPECT_RATIO:
 		return  "SET_ASPECT_RATIO";
 	case CX2341X_ENC_SET_DNR_FILTER_MODE:
-		return  "SET_DNR_FILTER_PROPS";
+		return  "SET_DNR_FILTER_MODE";
 	case CX2341X_ENC_SET_DNR_FILTER_PROPS:
 		return  "SET_DNR_FILTER_PROPS";
 	case CX2341X_ENC_SET_CORING_LEVELS:
