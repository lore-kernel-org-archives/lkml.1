Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYE1NGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYE1NGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYE1NGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:06:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58713 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYE1NGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:06:35 -0400
Date: Wed, 28 May 2008 14:06:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-input@vger.kernel.org
Cc: linu-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20080528130621.GA32646@srcf.ucam.org>
References: <20080523160955.GA19674@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523160955.GA19674@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH 1/3] Input: Add switch for dock events
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a SW_DOCK switch to input.h. ACPI docks currently send their docking 
status as a uevent, but not all docks are ACPI or correspond to a 
device. In that case, it makes more sense to simply generate an input 
event on docking or undocking.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/include/linux/input.h b/include/linux/input.h
index 28a094f..0bc55ee 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -638,6 +638,7 @@ struct input_absinfo {
 #define SW_TABLET_MODE		0x01  /* set = tablet mode */
 #define SW_HEADPHONE_INSERT	0x02  /* set = inserted */
 #define SW_RADIO		0x03  /* set = radio enabled */
+#define SW_DOCK			0x04  /* set = plugged into dock */
 #define SW_MAX			0x0f
 #define SW_CNT			(SW_MAX+1)
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
