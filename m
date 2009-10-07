Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZJGIRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZJGIRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbZJGIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:17:09 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:61531 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725AbZJGIRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GvlWCn6QRTaAZROi7e2lbAFbBotZVk7nEB2hQ0YMDnsfGUqvSrYYpfYIUywszyU2AK
         EGOL4uY/zcXWfutQ1r+KY1ZHU3UHKmoh8+qXHMT6K6SN3yiTM5Lih57jjVwsISneqYlY
         zv25+zV3Y7hhLwF1P/Hqyukji/Mdm3elHvNNs=
MIME-Version: 1.0
In-Reply-To: <20091007073121.GA31245@elf.ucw.cz>
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com>
	 <20090812005532.GA31003@srcf.ucam.org> <20090814163233.GC1626@ucw.cz>
	 <20090816074008.GA11624@1wt.eu> <4ACB59E2.3000600@amd.com>
	 <20091007073121.GA31245@elf.ucw.cz>
Date: Wed, 7 Oct 2009 18:16:29 +1000
Message-ID: <21d7e9970910070116h6cf4e472i309537e9b4bb1e08@mail.gmail.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
From: Dave Airlie <airlied@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Tippett, Matthew" <matthew.tippett@amd.com>, Willy Tarreau <w@1wt.eu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 5:31 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-10-06 10:53:22, Tippett, Matthew wrote:
>> (Resending as text-only - sorry)
>>
>> Bringing this item back up again.
>>
>> I am not suggesting that the application of any particular policy
>> appears within the kernel or userspace or a secondary policy engine.
>> In general I am also against codifying policy within drivers.
>>
>> I am interested seeing the ACPI notifier mechanism expanded to allow
>> AC/DC state changes propagate to other kernel drivers without requiring
>> a userspace in between.
>>
>> I can continue to come up with real scenarios that would possibly
>> require kernel-to-kernel notification, but would rather focus this
>> discussion of the pure technical issues associated with adding the
>> notifier to the AC/DC ACPI subsystem.
>
> Please do. So far you did not show valid use for such notifier.
>
> (Ok, I know of one. Old amd64 notebooks had cpufreq scaling enabled,
> with battery unable to supply enough current to feed the CPU at
> highest cpufreq setting. At that point, scaling cpufreq down at unplug
> is correctness issue, and AC/DC notifier in kernel makes
> sense.)
>
> So... what do you want to use it for?

I'm not sure we have a open driver use case for this, if not I suggest
we remove it and only add it when a user is added to the kernel.

Dave.
