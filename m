Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYIJKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYIJKx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYIJKxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:53:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:26420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYIJKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uSyaQvX1JxsL8Q7h3E2JRcUjOH16FPSMTd8U6zuAVRXXkv3wFQkX9Jq3f9V9vKP6ul
         PbX3Pp5ZOzfqMG6rPqZanpl1eIJAW2wOis53Ncpd2gMyAEHtOJWrWRWe0Y3Vm5iDRhQj
         JgSg61GP0jN/DjMmRy1xu26rNRoNO/S8OKw1E=
Message-ID: <aa79d98a0809100353t3f995bb3hf658e1bc66eaac7a@mail.gmail.com>
Date: Wed, 10 Sep 2008 14:53:47 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910093105.GA5259@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
	 <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
	 <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com>
	 <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
	 <20080910093105.GA5259@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 1:31 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Tue, Sep 9, 2008 at 11:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > ...
>> >>
>> >> hope we can keep using MACRO..
>> >>
>> >> YH
>> >>
>> >
>> > Btw, Yinghai, what does it mean? To not touch this macro at all?
>> > Or you mean about implementation issue (ie the design itself)?
>>
>> do not touch this macro... and may revisit after 2.6.28
>
> anything you are particularly worried about? Regressions we should be
> able to find pretty quickly, in a central macro like that - and the
> macro is quite ugly.
>
>        Ingo
>

Btw Ingo, don't apply this patch for now - I'll simplify it a bit.
I just overzealous with masks operation - 'and' and 'or' will
be more then enough without checking. I think I will do it today evening
so Yinghai could review it and say if he like it. Anyway the
patch could be just queued to satisfy any concerns :)
