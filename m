Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLDQ1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLDQ1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXLDQ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:26:56 -0500
Received: from mx0.towertech.it ([213.215.222.73]:54381 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750964AbXLDQ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:26:55 -0500
Date: Tue, 4 Dec 2007 17:26:34 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Bryan Wu <bryan.wu@analog.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/7] Blackfin RTC driver: the frequency function is in
 units of Hz, not units of seconds, so lock our driver down to 1 Hz
Message-ID: <20071204172634.50492e1e@i1501.lan.towertech.it>
In-Reply-To: <1195812512-25979-2-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	<1195812512-25979-2-git-send-email-bryan.wu@analog.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 18:08:26 +0800
Bryan Wu <bryan.wu@analog.com> wrote:

 Hi, I fannly got some time to review the patches. Seems ok, the
 only question is...

> static int bfin_irq_set_freq(struct device *dev, int freq)
>  {
> -	struct bfin_rtc *rtc = dev_get_drvdata(dev);
>  	stampit();
> -	rtc->rtc_dev->irq_freq = freq;
> -	return 0;
> +	return -ENOTTY;
>  }

 .. why ENOTTY here?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

