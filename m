Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXBYSMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXBYSMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932792AbXBYSMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:12:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:59136 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbXBYSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qU4BhhydTBxDaxgJDoOUqOxlLc6Axgw2wOoEhY0IxFk01NncbHtAPfoe+dz2AEaoMKMjaXtEQBQ2fq+LrOGwMion55z15+QtG9/A/dWBNh32LlCrDGDYFADCe6xwt66FA0dCvODGNcFKOV5/qhzNqpxc2APlqJ4udgSV9hAQM0c=
Message-ID: <4727185d0702251012l7114d6ccxb09dca96f03ae354@mail.gmail.com>
Date: Sun, 25 Feb 2007 19:12:35 +0100
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: linux-2.6.today: rtc_cmos init oops/panic inrtc_sysfs_remove_device()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had the same problem, and your patch fixes it.

I found that disabling CONFIG_RTC_DRV_CMOS
fixes^Wworkarounds it too...

Acked-by: Vincent Legoll <vincent.legoll@gmail.com>

-- 
Vincent Legoll
