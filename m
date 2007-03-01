Return-Path: <linux-kernel-owner+w=401wt.eu-S965548AbXCATuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548AbXCATuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXCATuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:50:22 -0500
Received: from mx0.towertech.it ([213.215.222.73]:51125 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965548AbXCATuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:50:20 -0500
Date: Thu, 1 Mar 2007 20:50:16 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "David Brownell" <david-b@pacbell.net>, akpm@linux-foundation.org,
       bryan.wu@analog.com, mm-commits@vger.kernel.org, a.zummo@towertech.it,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: + blackfin-on-chip-rtc-controller-driver.patch added to -mm
 tree
Message-ID: <20070301205016.078c3b32@inspiron>
In-Reply-To: <8bd0f97a0703011106j7cb3664dx190686b0251cd1fa@mail.gmail.com>
References: <200703010848.l218me3e008819@shell0.pdx.osdl.net>
	<200703011039.32876.david-b@pacbell.net>
	<8bd0f97a0703011106j7cb3664dx190686b0251cd1fa@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 14:06:49 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> > It's unclear why you
> > chose to report "pending" (irq issued but not yet acked) since
> > that's uselessly transient state on non-polled hardwre.  (That
> > flag definition came from EFI, a polled firmware RTC.)
> 
> because other drivers do ?  there is no documentation here that covers
> what exactly the read_alarm function in the rtc_class_ops is supposed
> to do which leaves it up to people looking at other drivers

 there has been a bit of confusion on this topic. I think it's 
 now the time to exactly define what should happen with
 alarms and how they should be reported back to the class.

 I'm usually inclined to agree with David on that particular topic :)

 other than that, I would like to remove the /proc interface in the
 future, so users are advised not to count on it and device
 authors to not add properties.

 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

