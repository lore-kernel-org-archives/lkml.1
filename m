Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbYHEXQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbYHEXQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbYHEXP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:15:58 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:10360 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbYHEXP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QQNfgLfaNDtEBcsKKhvjL9B4vq5WKJJ28Fmjct6NIKqA7vujZnuTrvUIziUnwkTq8W
         AL4ViW216754zjYEnSJvNvlLTYlufIxWyugASEqUyTnEDdzHgeuf5S+hT9cfjCcjVaKz
         Cc68htoa71OK7ewH1fXK441nKlSgLmriNmWXo=
Message-ID: <86802c440808051615h57baa06ci5ab040048786b50d@mail.gmail.com>
Date: Tue, 5 Aug 2008 16:15:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4898DBD8.4000002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <4898DBD8.4000002@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 4:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> Peter, Andrew,
>>
>> Please check dyn_array support for x86
>> v3: split changing to nr_irqs to small patches
>>    fix checkpatch error
>>    reorder the patch sequence to make dyn_array support go at first
>>        so could use that with arrays other than NR_IRQS
>>
>
> The real issue is that I think Eric is right: the dyn_array is an
> interesting data structure, but it's the wrong solution for the problem.  A
> static array would have to be ridiculously large given the potential number
> of interrupt sources.
>

i am working on dyn_array + condense irq_desc/irq_cfg.

it will use dyn_array to allocate 32 entry for irq_desc/irq_cfg, and
will use get_irq_desc via list to distribute it. later if need more,
will allocate more 32 entries....

so will send out v4.

YH
