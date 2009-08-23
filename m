Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbZHWN2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbZHWN2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbZHWN2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:28:46 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654AbZHWN2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dlIVADxCfaSSFXTbrvQK+Z42Ch0pzlYyNt/LjYeJKxAvbi/MaRckgU5vpV9DF3ihvO
         kYo0p9u1LczuxoQTHjZCzpbA/e/iIriF6pNTWZKyTNz2ChJrNp339D8E/x07LfEQKjSH
         IfStxOM7yS0seykSDwgDbkKuakozbQzDqynaA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:11 +0200
Message-Id: <20090823132911.17784.11300.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/33] Staging: rtxxxx: RTMPGetRalinkAuthModeStr() fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxxx: RTMPGetRalinkAuthModeStr() fixes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_info.c |    7 -------
 1 file changed, 7 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_info.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -2720,9 +2720,6 @@ PCHAR   RTMPGetRalinkAuthModeStr(
 	{
 		case Ndis802_11AuthModeOpen:
 			return "OPEN";
-#if defined(RT2860) || defined(RT30xx)
-        default:
-#endif
 		case Ndis802_11AuthModeWPAPSK:
 			return "WPAPSK";
 		case Ndis802_11AuthModeShared:
@@ -2737,14 +2734,10 @@ PCHAR   RTMPGetRalinkAuthModeStr(
 			return "WPAPSKWPA2PSK";
         case Ndis802_11AuthModeWPA1WPA2:
 			return "WPA1WPA2";
-#ifndef RT30xx
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
-#ifdef RT2870
 		default:
 			return "UNKNOW";
-#endif
-#endif
 	}
 }
 
