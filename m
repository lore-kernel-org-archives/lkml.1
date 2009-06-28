Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZF1PfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZF1PfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZF1PfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:35:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52414 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZF1PfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=c0TzIkS15W0iQOlaJpNnjPqIfsUl1ss10XFx1B9t5+Peo0TN3kVe09cG2MANu6a3nX
         6JHmX2dZgSBOedCMC3TxJCQV90uouUDF6FCKOo658e6VILafboANUx6aAVfqcQ6Gp4Cb
         UcVStnbW/i9BCWkqY2RUxTtonYlAdeVzKC7sw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] Staging: rtl8192su: add TODO
Date: Sun, 28 Jun 2009 17:40:50 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906281740.50426.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/TODO |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: b/drivers/staging/rtl8192su/TODO
===================================================================
--- /dev/null
+++ b/drivers/staging/rtl8192su/TODO
@@ -0,0 +1,23 @@
+TODO:
+- make ieee80211 stack private (may conflict with libipw currently)
+- prepare private ieee80211 stack for merge with rtl8187se's version:
+  - remove JOHN_DUMP[_DESC] ifdefs
+  - remove [IN]_OPENSUSE_SLED definitions
+  - remove superflous container_of definition from ieee80211.h
+  - remove superfluous ieee80211_* definitions from ieee80211.h
+  - remove rtl8192su's specific dead code
+  - cleanup ieee80211.h
+  - move rtl8192su's specific code out from ieee80211.h
+  - abstract rtl819su's specific code
+  - use list_for_each_safe() in ieee80211_crypto_deinit
+- switch to use shared "librtl" instead of private ieee80211 stack
+- switch to use LIB80211
+- switch to use MAC80211
+- switch to use EEPROM_93CX6
+- use kernel coding style
+- checkpatch.pl fixes
+- sparse fixes
+- integrate with drivers/net/wireless/rtl818x
+
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
+Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>.
