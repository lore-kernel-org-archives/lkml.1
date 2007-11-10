Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXKJTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXKJTts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbXKJTtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:49:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:37751 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXKJTti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:49:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fZa5GGNzinuyjz89wt4ezYIWfVqgcFmi4ukfiHx7hIpGPrMTy4HPg81kCW9pc28No2s8G1DSGCKTZJZj/7lu6DKdyOZK5g4yhcVb4+howCJY0sfLHqJz+/MAjSpIeNbxvW7s25ISQPUgpYRnS9q0yR2q2oWxwKsiyo84tsR9bpA=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: Remove unnecessary code in iwl3945 and iwl4965 drivers
Date: Sat, 10 Nov 2007 20:49:32 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711102049.32921.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecesary code in iwl3945 and iwl4965 drivers.

"final_mode" variable is already initialized with the value of the "mode" variable.

Signed-off-by: Miguel Boton <mboton@gmail.com>

Index: linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2377,9 +2377,6 @@
 	case IWL_POWER_AC:
 		final_mode = IWL_POWER_MODE_CAM;
 		break;
-	default:
-		final_mode = mode;
-		break;
 	}
 
 	iwl_update_power_cmd(priv, &cmd, final_mode);
Index: linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2233,9 +2233,6 @@
 	case IWL_POWER_AC:
 		final_mode = IWL_POWER_MODE_CAM;
 		break;
-	default:
-		final_mode = mode;
-		break;
 	}
 
 	cmd.keep_alive_beacons = 0;

-- 
	Miguel Botón
