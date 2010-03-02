Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0CBVVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:21:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60582 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0CBVVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nz1f+9ejEHroAZlxu0OT1xG4eBj4WDltPEaluj2t13rTrL9YQZ9UOJ3QWQDB80y0Lu
         0hus011tUkfmzfOM961TaSReHlYutB/OFaoQtOm0sE/siRjRNcm77gVc84V9dtsvCVHG
         8sja7FbSpmzPcbyy+Ys7NZWcwMympt1hCtxcA=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c21003021306w3546521dsd1ad50893f1ea44b@mail.gmail.com>
References: <1267560734-17001-1-git-send-email-linus.walleij@stericsson.com>
	 <e9c3a7c21003021306w3546521dsd1ad50893f1ea44b@mail.gmail.com>
Date: Tue, 2 Mar 2010 14:21:40 -0700
X-Google-Sender-Auth: 3f4dbb845462f793
Message-ID: <e9c3a7c21003021321h7df40afep2a3c82c6d429cf47@mail.gmail.com>
Subject: Re: [PATCH 1/5] DMAENGINE: COH 901 318 cleanups
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 2:06 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Mar 2, 2010 at 1:12 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>>        if (cohc->nbr_active_done)
>> +       /*
>> +        * If another interrupt fired while the tasklet was scheduling,
>> +        * we don't get called twice, so we have this number of active
>> +        * counter that keep track of the number of IRQs expected to
>> +        * be handled for this channel. If there happen to be more than
>> +        * one IRQ to be ack:ed, we simply schedule this tasklet again.
>> +        */
>>                cohc->nbr_active_done--;
>
> Checkpatch made a justifiable wimper about this.  It looks like you
> wanted to delete that if() according to the previous unified patch?
>

Looks like it gets deleted later on in patch #3.  I took a stab at
fixing it up[1], or you can just send me a new series if that does not
look right to you.

--
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=refs/heads/coh
