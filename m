Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZLJPiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZLJPiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZLJPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:38:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40109 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZLJPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:38:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=PNNfi+FdPlqnwAdVA9wm6UBfJK3bXOYN6cSvMqdUK7zUWsw7FG4vlJbddIjt81CMLC
         ljNfQlLhRauyYD/vEWneKNz0jj+HUIO3pCGMDmbMUnLxsoe+3RcCeEIdoKgbbUcEFFtf
         +YMB0tCHG5Z6Pv1PglCP8XeZQ8dJGPUvkqk1s=
Message-ID: <4B211640.807@gmail.com>
Date: Thu, 10 Dec 2009 16:39:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: Fix branch in zfProtRspSim()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semicolon is misplaced.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/otus/80211core/ctxrx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/otus/80211core/ctxrx.c b/drivers/staging/otus/80211core/ctxrx.c
index e258a7d..7730e2c 100644
--- a/drivers/staging/otus/80211core/ctxrx.c
+++ b/drivers/staging/otus/80211core/ctxrx.c
@@ -536,8 +536,7 @@ void zfProtRspSim(zdev_t* dev, zbuf_t* buf)
         zm_msg2_rx(ZM_LV_2, "ip1=", dip[1]);
 
         //ARP request to 192.168.1.15
-        if ((arpOp == 0x0100) && (dip[0] == 0xa8c0) && (dip[1] == 0x0f01));
-        {
+        if ((arpOp == 0x0100) && (dip[0] == 0xa8c0) && (dip[1] == 0x0f01)) {
             zm_msg0_rx(ZM_LV_2, "ARP");
             /* ARP response */
             zmw_rx_buf_writeh(dev, buf, 20, 0x0200);
