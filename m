Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbZFQOfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbZFQOfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZFQOez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:34:55 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:58297 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbZFQOey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XGYYUR9lt98RfJnNoGwOwMuUmSu7Obn6vjg7OVqssCsKMVpD8CLKFYrPJHJeVXwxjZ
         ATgTyqA8VCncR1oO04Hh46KeBfOX24tt9jBZAbZX2V6KZn4mN7y/K51a81Mxe5lURFZi
         BOAeag09pYvgj8NKe5aaNugmHe3Iwk2YY7yVw=
MIME-Version: 1.0
In-Reply-To: <20090617132947.GA6476@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	 <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	 <20090526213346.GA7073@redhat.com>
	 <20090527005527.B50B7FC36B@magilla.sf.frob.com>
	 <20090602045418.GB8219@us.ibm.com>
	 <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
	 <20090606064749.GA13508@redhat.com>
	 <f5a7b3810906170135q3fd90f8fy8c5e06ab77e26b52@mail.gmail.com>
	 <20090617132947.GA6476@redhat.com>
Date: Wed, 17 Jun 2009 20:04:57 +0530
Message-ID: <f5a7b3810906170734q814c616o155509561e961244@mail.gmail.com>
Subject: Re: open_posix_testsuite: STOP + CONT + wait hang?
From: naresh kamboju <naresh.kernel@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much.
just before i have reported the same issue to ARM Kernel mailing list.


Best regards,
Naresh Kamboju

On Wed, Jun 17, 2009 at 6:59 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> On 06/17, naresh kamboju wrote:
>>
>> please find inline comments
>
> Thanks Naresh.
>
>> >> ARCH: ARM
>> >
>> > is it ARM specific? I can't reproduce the problem on x86.
>> yes it is specific to ARM. test cases are PASSED on X86-2.6.29 Kernels.
>
> Not good, because I know nothing about arm and don't have the arm machine ;)
> Will try to look...
>
>> > If you can reproduce the problem, please send the content of
>> > /proc/CHILD_PID/status and /proc/PARENT_PID/status.
>>
>> i have attached  strace and proc_log
>> please review the same.
>
> Thanks.
>
> Could you reproduce without strace, and send the output of /proc/xxx/status ?
> I don't really expect we will see something interesting, but just in case.
>
> Also, the output of sysrq-t may help. (the part which relates to these 2
> processes).
>
> Oleg.
>
>
