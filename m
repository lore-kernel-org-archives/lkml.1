Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZDWPDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZDWPDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZDWPC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:02:57 -0400
Received: from mx0.towertech.it ([213.215.222.73]:53804 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753655AbZDWPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:02:57 -0400
Date: Thu, 23 Apr 2009 17:02:53 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       david-b@pacbell.net, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Message-ID: <20090423170253.6b6dfd21@i1501.lan.towertech.it>
In-Reply-To: <20090423.235141.61509229.anemo@mba.ocn.ne.jp>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20090409153921.04b6384c.akpm@linux-foundation.org>
	<20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<20090423.235141.61509229.anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 23:51:41 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> The IRQF_DISABLED fixes would be better regardless of the
> rtc_update_irq() API change.  And local_irq_disable fixes are not
> needed (and should be reverted) if the API change was acked, but no
> harm for short term fix.

 As I said in my last email to Andrew, I think we can call
 rtc_update_irq with irqs enabled and we don't probably need
 any IRQF_ to request_irq . 
 
 Are you willing to make some tests in that direction with your
 drivers?
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

