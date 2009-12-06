Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbZLFM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbZLFM2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZLFM2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:28:20 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:57491 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbZLFM2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:28:19 -0500
X-Greylist: delayed 90558 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 07:28:19 EST
References: <2a6e8c0d0912052133v3e112bdbx2c95b17437bdd182@mail.gmail.com>
Message-ID: <cone.1260102503.848391.3159.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Ian =?UTF-8?B?RS4=?= Morgan <penguin.wrangler@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: acerhdf: BIOS product mismatch due to whitespace
Date: Sun, 06 Dec 2009 13:28:23 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian E. Morgan writes:

> Peter,
> 
> Having just upgraded my AOA150 to 2.6.32, acerhdf was complaining:
> 
> acerhdf: Acer Aspire One Fan driver, v.0.5.18
> acerhdf: unknown (unsupported) BIOS version Acer/AOA150
> /v0.3310, please report, aborting!
> 
> DMI reports the product as "AOA150         " (i.e. 9 spaces after the
> 6-character model name). This causes the product match to fail, so I
> had to use force_product="AOA150".
> 
> acerhdf: Acer Aspire One Fan driver, v.0.5.18
> acerhdf: forcing BIOS product: AOA150
> 
> Then all was happy again. Any chance you could strip leading/trailing
> whitespace in the product match to avoid this issue?

Hi Ian,

thanks for reporting, will take care about this issue.

kind regards,
--peter

