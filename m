Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZDWPHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZDWPHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZDWPHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:07:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:31000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbZDWPHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hObIw9e2fR9mDp7F8nRHOQ8I2j0KKdDE1ckGBhlrZmVB4zmrEmWbd7YL8MwGSKtrTr
         lxW2Awe2wj5z7fxXe6rb8Qgsj2OqpEsVCGrjdbYilide+5P39by4wGxhAd4GudxNLQ3D
         nyU9j+In//iR+oCckYme/07nowCW7hCKI5vf0=
MIME-Version: 1.0
In-Reply-To: <20090423170253.6b6dfd21@i1501.lan.towertech.it>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <20090409153921.04b6384c.akpm@linux-foundation.org>
	 <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	 <20090423.235141.61509229.anemo@mba.ocn.ne.jp>
	 <20090423170253.6b6dfd21@i1501.lan.towertech.it>
Date: Thu, 23 Apr 2009 11:07:38 -0400
Message-ID: <8bd0f97a0904230807q6c40436wa561d7b26db26cef@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with 
	irqs enabled
From: Mike Frysinger <vapier.adi@gmail.com>
To: rtc-linux@googlegroups.com
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       david-b@pacbell.net, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 11:02, Alessandro Zummo wrote:
> On Thu, 23 Apr 2009 23:51:41 +0900 (JST) Atsushi Nemoto wrote:
>> The IRQF_DISABLED fixes would be better regardless of the
>> rtc_update_irq() API change.  And local_irq_disable fixes are not
>> needed (and should be reverted) if the API change was acked, but no
>> harm for short term fix.
>
>  As I said in my last email to Andrew, I think we can call
>  rtc_update_irq with irqs enabled and we don't probably need
>  any IRQF_ to request_irq .
>
>  Are you willing to make some tests in that direction with your
>  drivers?

we just removed the shared bit from the Blackfin rtc driver because it
didnt really make sense for us.  i need to test something else, so is
the only change you need is the one posted originally ?  that makes
more sense to me than forcing everyone to use IRQF_DISABLED.
-mike
