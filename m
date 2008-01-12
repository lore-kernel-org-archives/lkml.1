Return-Path: <linux-kernel-owner+w=401wt.eu-S1762358AbYALWuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762358AbYALWuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYALWu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:50:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:34096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbYALWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zs5aAMM5KYDuErVNZyRgiyz0FtJ2NHu4Bc3djaEdHJHlJ6/7PVYFkWtdWOmgL1q3M09KRgTp3pm5MJivQi+1Ce6pAkZjBi8FmSCuyV9jvWbDT9nRuN8xspNU48gvgArjwJ2hafrSXaRzlkAXQgXE/YSiUwZczfD7QokoiSDO3X4=
Date: Sun, 13 Jan 2008 01:50:16 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org, cbou@mail.ru,
       dwmw2@infradead.org
Subject: Re: [PATCH] pda_power: add device_init_wakeup
Message-ID: <20080112225016.GA24957@doriath.ww600.siemens.net>
References: <20080109163952.GA29397@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109163952.GA29397@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please apply this patch. Otherwise pda_power can't generate wakeup
events. I forgot this in the initial pda_power suspend/resume patch.

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

