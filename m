Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZI3TAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZI3TAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZI3TAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:00:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbZI3TAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:00:04 -0400
Date: Wed, 30 Sep 2009 11:59:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, herton@mandriva.com.br,
       linux-kernel@vger.kernel.org, david-b@pacbell.net
Subject: Re: [rtc-linux] Re: rtc_cmos oops in cmos_rtc_ioctl
Message-Id: <20090930115937.b6af1326.akpm@linux-foundation.org>
In-Reply-To: <20090922211546.44c0cf56@i1501.lan.towertech.it>
References: <200909211553.38409.herton@mandriva.com.br>
	<20090922124041.62abee25@i1501.lan.towertech.it>
	<200909221515.26777.herton@mandriva.com.br>
	<20090922211546.44c0cf56@i1501.lan.towertech.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 21:15:46 +0200
Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> On Tue, 22 Sep 2009 15:15:26 -0300
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> > 
> > Something like this?:
> > 
> > From a94365843ab40a1904c4bc244af4e551f2f2aca9 Mon Sep 17 00:00:00 2001
> > From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Date: Tue, 22 Sep 2009 13:46:00 -0300
> > Subject: [PATCH] rtc-cmos: convert RTC_AIE/RTC_UIE to rtc irq API
> > 
> > Drop ioctl function that handles RTC_AIE/RTC_UIE, and use instead the
> > rtc subsystem API (alarm_irq_enable/update_irq_enable callbacks).
> > 
> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> 
>  Looks nice. David?
> 

I couldn't bear the suspense, so in a spirit of brave curiosity, I
applied the patch!

