Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0CKDl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:41:57 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:58401 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0CKDl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qg1y9Qo1ZE+qSEb57dOD2ibzqxCAqqbZej6XAzLCatyrY+LjcBDciAPlWf+zkJVNSn
         6wHYXXpiD14t2VNJM4zTLGBEw1agBgXz+BZHPCIRAlXIDHPQI9yranhsf8ItGBy82Ts6
         fe3Z4dl4wCLa4hDPIg+nrvgs+Hg6g9KAmmtmM=
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such
 as BTB and RAS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx <zhangfx@lemote.com>, yanh <yanh@lemtoe.com>
In-Reply-To: <4B98632E.70806@necel.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
	 <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
	 <4B98632E.70806@necel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 11 Mar 2010 11:35:20 +0800
Message-ID: <1268278520.17798.5.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 12:27 +0900, Shinya Kuribayashi wrote:
> Wu Zhangjin wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > As the Chapter 15: "Errata: Issue of Out-of-order in loongson"[1] shows, to
> > workaround the Issue of Loongson-2F，We need to do:
> > 
> > "When switching from user model to kernel model, you should flush the branch
> > target history such as BTB and RAS."
> 
> Just wondered, model or mode?
> 

Hmm, should be mode.

> > This patch did clear BTB(branch target buffer), forbid RAS(row address strobe)
> > via Loongson-2F's 64bit diagnostic register.
> 
> Are you sure that RAS represents "Row Address Strobe", not "Return
> Address Stack?"
> 

Hi, Yanhua(from Lemote), can you help to clear this part?

> By the way, we have a similar local workaround for vr55xx processors
> when switching from kernel mode to user mode.  It's not necessarily
> related to out-of-order issues, but we need to prevent the processor
> from doing instruction prefetch beyond "eret" instruction.
> 
> In the long term, it would be appreciated that the kernel has a set
> of hooks when switching KUX-modes, so that each machine could have
> his own, processor-specific treatmens.
> 

Good idea.

Thanks!

Regards,
	Wu Zhangjin

