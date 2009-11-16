Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZKPCgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZKPCgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZKPCgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:36:20 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33316 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZKPCgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:36:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YqpWbWTMDf5Txek21mph4+KLcKZlhxUrW+39LJEOI56zJT9nTvCIyIGp3RAwqbOBur
         PtVVr/hn6/2pWa0dSemwN3ZRbJznJNpq7/4EvO/e5uJKuEwwa+0TR9jt/TRwcIiT6sYZ
         FNRTkOsglR/4l/98kZmKb4Ak2pLrg8NPoL5qM=
MIME-Version: 1.0
In-Reply-To: <1258221909.3299.26.camel@violet>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <1258082571.7715.13.camel@violet>
	 <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
	 <1258216474.3299.24.camel@violet>
	 <4fb5db50911140937j278584e5nf9e4d5767a44a920@mail.gmail.com>
	 <1258221909.3299.26.camel@violet>
Date: Mon, 16 Nov 2009 08:06:23 +0530
Message-ID: <4fb5db50911151836u5b4844adrd91b56a5ebc7084d@mail.gmail.com>
Subject: [PATCH 1/1] Adding radio type FM
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: majordomo@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding changes  RFKILL type FM  and for RFKILL for FM  in core

>From 4bf0ae6c90de9a766914abeb5ab5e5428089b648 Mon Sep 17 00:00:00 2001
From: Janakiram Sistla <janakiram.sistla@gmail.com>
Date: Mon, 16 Nov 2009 07:58:09 +0530
Subject: [PATCH 1/1] Adding radio type FM

Adding radio type FM in RFKILL_TYPE_.FM belongs to
same class of with both TX/RX capability.

Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
---
 include/linux/rfkill.h |    1 +
 net/rfkill/core.c      |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 3392c59..03f5598 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -45,6 +45,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
+	RFKILL_TYPE_FM,
 	NUM_RFKILL_TYPES,
 };

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index ba2efb9..61b716e 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -590,6 +590,8 @@ static const char *rfkill_get_type_str(enum
rfkill_type type)
 		return "wimax";
 	case RFKILL_TYPE_WWAN:
 		return "wwan";
+	case RFKILL_TYPE_FM:
+		return "fm";
 	case RFKILL_TYPE_GPS:
 		return "gps";
 	default:
-- 
1.5.4.3
