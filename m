Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182Ab0ARLXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0ARLXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635Ab0ARLXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:23:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51336 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0ARLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=rTDbRCa/3eqFm5UhDkZgVxvgvQ/aTaJRYj+Ry6IxUxdDg7Vvy/LVGgWyiGnpGcIQRa
         BPduuGkU7ej9cQH6+pMZ6kCs7vrjDcNJi6d2v3uhSVlxCDBurlQGLfbQTuSYnKYsvYEo
         zm1FqvqGIhTw/Cc/qwp1z3Wx/euCjC2prdkEU=
Date: Mon, 18 Jan 2010 14:23:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [patch] staging/rtl8187se: fix if statement
Message-ID: <20100118112319.GB31923@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I removed a misplace semicolon.  It is clear from the indentation that 
TxPwrTracking87SE() was only supposed to be called if CheckTxPwrTracking()
returned true.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/staging/rtl8187se/r8180_core.c	2010-01-18 08:27:05.000000000 +0300
+++ devel/drivers/staging/rtl8187se/r8180_core.c	2010-01-18 08:27:40.000000000 +0300
@@ -2566,7 +2566,7 @@ void watch_dog_adaptive(unsigned long da
 	// Tx Power Tracking on 87SE.
 #ifdef TX_TRACK
 	//if( priv->bTxPowerTrack )	//lzm mod 080826
-	if( CheckTxPwrTracking((struct net_device *)data));
+	if (CheckTxPwrTracking((struct net_device *)data))
 		TxPwrTracking87SE((struct net_device *)data);
 #endif
 
