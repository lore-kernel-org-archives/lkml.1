Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYDBMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYDBMqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYDBMqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:46:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26247 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYDBMp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Y3MLfMZKqsjeRrDRpnzFHGHfPxvjDhg6x+aFJYiAR3ZnM+VxFgFq05XEWE4kjVYTtXz/j2+p+qbr6F1lnkTpPYdm9Qha+eo1ttlSPftkZb7bog+jaPDdwUV7pk48AHLER1kmTQdH5BPugIIoIPwJNG+h6ojUGUQcOKH+/HKH8V4=
Message-ID: <47F37FF6.50206@gmail.com>
Date: Wed, 02 Apr 2008 16:45:42 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [MIPS] unexport null_perf_irq() and make it static
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>	<1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com> <20080402.213817.74752727.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080402.213817.74752727.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto пишет:
> On Wed,  2 Apr 2008 03:58:38 +0400, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
>> --- a/arch/mips/oprofile/op_model_mipsxx.c
>> +++ b/arch/mips/oprofile/op_model_mipsxx.c
>> @@ -31,6 +31,8 @@
>>  
>>  #define M_COUNTER_OVERFLOW		(1UL      << 31)
>>  
>> +int (*save_perf_irq)(void);
> 
> This should be another target of "make it static" patch :-)

Indeed. Thank you for noticing that.

> 
> ---
> Atsushi Nemoto
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

