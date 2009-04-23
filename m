Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZDWPho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZDWPho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZDWPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:37:32 -0400
Received: from mx0.towertech.it ([213.215.222.73]:56999 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753977AbZDWPhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:37:31 -0400
Date: Thu, 23 Apr 2009 17:37:28 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: vapier.adi@gmail.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, david-b@pacbell.net,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
  irqs enabled
Message-ID: <20090423173728.4fa010fa@i1501.lan.towertech.it>
In-Reply-To: <8bd0f97a0904230807q6c40436wa561d7b26db26cef@mail.gmail.com>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20090409153921.04b6384c.akpm@linux-foundation.org>
	<20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<20090423.235141.61509229.anemo@mba.ocn.ne.jp>
	<20090423170253.6b6dfd21@i1501.lan.towertech.it>
	<8bd0f97a0904230807q6c40436wa561d7b26db26cef@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 11:07:38 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

> we just removed the shared bit from the Blackfin rtc driver because it
> didnt really make sense for us.  i need to test something else, so is
> the only change you need is the one posted originally ?  that makes
> more sense to me than forcing everyone to use IRQF_DISABLED.

 for the blackfin you should just check if
 you have locking issues in your irq routine

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

