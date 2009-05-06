Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZEFGyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZEFGyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZEFGyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:54:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:36451 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZEFGyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XRvMYuGPEGe8j/909szW+VpTzllLOZV4Lmg714Aa10kNWM28r6s0bxf8Mbsx3nytO4
         8YqVwe0BUwNflCZpf4ZxgxY+30inTPxeDdkVhyEfLxafpDPjynMHzfwdC3g5S5MTZiKq
         bfepbavPa1AhrN7N0WNkchyfiHROr/UfVEOqQ=
MIME-Version: 1.0
In-Reply-To: <20090506064529.GA14326@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de>
	 <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com>
	 <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com>
	 <20090504113751.GA22603@avionic-design.de>
	 <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com>
	 <20090504145700.GA875@avionic-design.de>
	 <483a38b80905052125r76358182g7ce6b890c921b655@mail.gmail.com>
	 <20090506064529.GA14326@avionic-design.de>
Date: Wed, 6 May 2009 15:54:20 +0900
Message-ID: <483a38b80905052354m221ddc03tcbe9d35ee902b467@mail.gmail.com>
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 3:45 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> * Kwangwoo Lee wrote:
> [...]
>> Thanks for the patch. It looks good. :)
>> The code in the patch is already merged in the main kernel tree.
>>
>> @@ -235,7 +245,7 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
>>       spin_lock_irqsave(&ts->lock, flags);
>>
>>       if (likely(ts->get_pendown_state())) {
>> -             disable_irq(ts->irq);
>> +             disable_irq_nosync(ts->irq);
>>               hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
>>                                       HRTIMER_MODE_REL);
>>       }
>
> Oh, I hadn't noticed. I diffed against 2.6.30-rc4. Do you want me to send a
> new patch or will you just rip that piece out?

Send fixed patch with your Signed-off-by line.

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
