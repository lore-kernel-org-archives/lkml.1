Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbYBUUaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbYBUUaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759686AbYBUU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:29:57 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:33527 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbYBUU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:29:56 -0500
X-SBRS: 3.5
X-MesageID: 42967176
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,388,1199682000"; 
   d="scan'208";a="42967176"
Date: Thu, 21 Feb 2008 21:26:40 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: VT notifier fix for VT switch
Message-ID: <20080221202640.GA10976@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notify when VT switch is complete.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux-2.6.24-orig/drivers/char/vt.c	2008-01-25 09:32:06.000000000 +0100
+++ linux-2.6.24-perso/drivers/char/vt.c	2008-02-21 15:51:13.000000000 +0100
@@ -702,6 +702,7 @@
 	if (is_switch) {
 		set_leds();
 		compute_shiftstate();
+		notify_update(vc);
 	}
 }
 
