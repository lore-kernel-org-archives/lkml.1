Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYAIQkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYAIQkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYAIQkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:40:00 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:35981 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYAIQj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=hI7GlujAd2xpVN4IIYZBNnSzYeXGs7K8p7LFEYyXxUiFRyZiVOvFVHN10UiZHyIxq0TgNfGaq7lFg6+5ELngz/Bq/zYjdXFRmBSqeRNxObonbd3J7JJDNPWuGSRVTKmvIU5ku1hvpNhTuAz5pmbVKN4CUvDMbIsI6gdh0fZ8Pb0=
Date: Wed, 9 Jan 2008 19:39:52 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org, cbou@mail.ru,
       dwmw2@infradead.org
Subject: [PATCH] pda_power: add device_init_wakeup
Message-ID: <20080109163952.GA29397@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device_init_wakeup to init wakeup.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index d98622f..28360e8 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -207,6 +207,8 @@ static int pda_power_probe(struct platform_device *pdev)
 		}
 	}
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	return 0;
 
 usb_irq_failed:
-- 
With best wishes
Dmitry

