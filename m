Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYLIW0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYLIW0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYLIW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:26:08 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:49577 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbYLIW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=TB43xMbIAX1SHXf+AcMoUV2mQo9e5DUjS7f674+yc93V4mKMNzr0kQ5BRwzcIzUFEp
         3Fd3rZ23I/QGmcVWEvdKO5Q+ybQh8uXyTGCOqFTz1LdQs5f5U4XOCRyF1JKvqngNhohO
         JktI8QShEVWV1d+3dHd20jF07kFFmRGDH9/2w=
Message-ID: <493EF07D.4010405@gmail.com>
Date: Tue, 09 Dec 2008 23:26:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: tiwai@suse.de, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/31] sound: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 sound/usb/usx2y/usb_stream.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stream.c
index ff23cc1..70b9635 100644
--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -276,7 +276,8 @@ static void subs_set_complete(struct urb **urbs, void (*complete)(struct urb *))
 	}
 }
 
-int usb_stream_prepare_playback(struct usb_stream_kernel *sk, struct urb *inurb)
+static int usb_stream_prepare_playback(struct usb_stream_kernel *sk,
+		struct urb *inurb)
 {
 	struct usb_stream *s = sk->s;
 	struct urb *io;

