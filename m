Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZKUNpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZKUNpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZKUNjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:39:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZKUNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:39:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Ri9d/e7GpdcPGOWYHiNVSixu3oAzAkmUgGPAtU2DZT3c7QrzGDl4yTj361MCYV+vV4
         nSR3+kMHfDVmOwYCYi85r9+ZKneprHlTQAJjoqq+fcma60tyKZ5rfA1xLaEI61YzIPfk
         Dvuf8nH9XWqzklfmbNpYjQ9FJ+rq/4kQPik50=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 1/9] Serial: Enable build of sc26xx driver for embedded
	platforms
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:39:55 +0100
Message-ID: <20091121133955.16090.84664.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index e522572..d9a98d4 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1395,7 +1395,7 @@ config SERIAL_QE
 
 config SERIAL_SC26XX
 	tristate "SC2681/SC2692 serial port support"
-	depends on SNI_RM
+	depends on SNI_RM || EMBEDDED
 	select SERIAL_CORE
 	help
 	  This is a driver for the onboard serial ports of

