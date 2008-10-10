Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYJJMza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYJJMza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbYJJMzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:55:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:7631 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbYJJMzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=Wv1zycIGVaYkuJvxh0HlCrDMte3KFPGNHHfONDrY1zBMznyymdP7199i3+NbMO3zXH
         2pAPdFdNnfxGdpgOlodPxl/sbSzBV4OZ1xiaoSrQX67j97TiTPhE2mdltrMez4jniMWV
         zPy8X3g5ZS/yJNl69b+MlXl/6gZG1ZVz+eyOE=
Message-ID: <48EF50B1.8070705@tuffmail.co.uk>
Date: Fri, 10 Oct 2008 13:55:13 +0100
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during
   initcalls
References: <20081010103615.EFB18D1BB8F@perso1.free.fr> <20081010105819.GA4699@elte.hu> <c62985530810100402of7e1b48n4aac01d69433c1f5@mail.gmail.com> <20081010110445.GA12519@elte.hu>
In-Reply-To: <20081010110445.GA12519@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
>> 2008/10/10 Ingo Molnar <mingo@elte.hu>:
>>> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>
>>>> We used to disable the initcall tracing at a specified time (IE: end
>>>> of builtin initcalls). But we don\'t need it anymore. It will be
>>>> stopped when initcalls are finished. However we want two things:
>>>>
>>>> _Start this tracing only after pre-smp initcalls are finished. _Since
>>>> we are planning to trace sched_switches at the same time, we want to
>>>> enable them only during the initcall execution. For this purpose, this
>>>> patch introduce two functions to enable/disable the sched_switch
>>>> tracing during boot.
>>>>
>>>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>>> applied to tip/tracing/fastboot, thanks Frederic!
>>>
>>>        Ingo
>>>
>> Oops, sorry Ingo there are some backslashes that taint this patch.
>> I will resend a V2....
> 
> dont worry, i fixed them already when i applied your patch (and that's 
> all in latest tip/master).
> 
> See the commit below - i sanitize most commit entries to make subject 
> lines more consistent (note the capitalization difference between your 
> submission and the end result), to improve paragraphing and general 
> structure.

You missed the one backslash though...

> -/* Should be started after do_pre_smp_initcalls() in init/main.c */
> +/* Tells the boot tracer that the pre_smp_initcalls are finished.
> + * So we are ready .
> + * It doesn\'t enable sched events tracing however.
> + * You have to call enable_boot_trace to do so.
> + */

Alan
