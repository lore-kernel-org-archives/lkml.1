Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYIQSLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYIQSLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYIQSK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:10:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:50368 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbYIQSK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R6LdAAsXKR4I4ClexPzIeTpeUE56iXWuZREbGu7/46YYezXhbearqlYwSweoQ0VqI5
         RMZPsP6XQHaG+gVSRgmNh0XLmdB8SvuJ31XgrbMvbORVWYThjoA/YKlEDuTbGlVeTRew
         0UqItvo4nKQyleeViXgQWbp6tfIXLLkTS5dSY=
Message-ID: <86802c440809171110y3b91e27q382c6ee7bcd58c28@mail.gmail.com>
Date: Wed, 17 Sep 2008 11:10:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48D13960.2020902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080917073058.GA3770@x200.localdomain>
	 <20080917084754.GC24035@elte.hu> <48D13960.2020902@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 10:07 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>
>> the subsystem tags should be cut out by dmesg by default, just like the
>> normal <1> tags are cut out.
>>
> [...]
>>
>> and it's bad and a showstopper if the default output of 'dmesg' degrades,
>> like your noticed - those are bugs in the concept and need to be fixed.
>>
>
> It's probably worth pointing out that we had similar transition pains when
> we introduced the loglevel tags.  If you used an old dmesg/klogd you got the
> loglevel tags; we cleaned them up.

want to expand loglevel tags to two digi bits, hope the dmesg/klogd
could handle it.

YH
