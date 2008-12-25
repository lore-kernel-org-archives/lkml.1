Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbYLYOqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbYLYOqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYLYOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:46:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:23378 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYLYOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:46:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JxMbb5GFHAtcJauTO1sfrRTmg3rwp/GTA4rVsAja30ePwaiB1Czg8wCroqDrTiRX3d
         hVy+BCMgS70PXXWg7cQ5Cp0pI83ou8CH16CAp1xaMs6vmFaQg0Hk+U5rzd7/qvCzq+Lh
         /ElBK47JhcLD4FW6d4NtV1DcYki0bi8OWPhUg=
Message-ID: <2f11576a0812250646hc5759afk3667610c653cc600@mail.gmail.com>
Date: Thu, 25 Dec 2008 23:46:21 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225105915.GA11560@elte.hu>
	 <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: bf3b1950f8244700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/25 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> > > +#include <linux/irq.h>
>> >
>> > looks good, but linux/irq.h cannot be included on all architectures. (for
>> > example s390 has no notion of 'hardirqs'). But we created linux/irqnr.h
>> > for this purpose - so including that should work better.
>>
>> Oh, thanks good explain.
>> I'll fix soon.
>
> next spin is here.
> I confirmed three architecture.
>
>  1. alpha (without SPARSE_IRQ, build test by cross compiler only)
>  2. ia64 (without SPARSE_IRQ)
>  3. x86_64 (with SPARSE_IRQ)

sorry.
this patch still don't work on !CONFIG_GENERIC_HARDIRQS arch. maybe.

I'll fix again.
