Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbYJJLCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbYJJLCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYJJLCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:02:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:28730 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbYJJLCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Jjsq9zVZ968IJm5aFyEQwILgYMaPQ4YsUWPzj6hdhGBXZuXJ2/+qrhAMsanFs9fKhx
         ACK7cyJ4GV89dMl/FCEH4Od0LpO2uotoW+A+ZCydCGFMmFaW1FTxA7Iin6M8uVvdx7Uy
         daSuZL2KEHgGRyEbgvQAcc8nG3a+7053edem8=
Message-ID: <c62985530810100402of7e1b48n4aac01d69433c1f5@mail.gmail.com>
Date: Fri, 10 Oct 2008 13:02:18 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during initcalls
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010105819.GA4699@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010103615.EFB18D1BB8F@perso1.free.fr>
	 <20081010105819.GA4699@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/10 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> We used to disable the initcall tracing at a specified time (IE: end
>> of builtin initcalls). But we don\'t need it anymore. It will be
>> stopped when initcalls are finished. However we want two things:
>>
>> _Start this tracing only after pre-smp initcalls are finished. _Since
>> we are planning to trace sched_switches at the same time, we want to
>> enable them only during the initcall execution. For this purpose, this
>> patch introduce two functions to enable/disable the sched_switch
>> tracing during boot.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>
> applied to tip/tracing/fastboot, thanks Frederic!
>
>        Ingo
>

Oops, sorry Ingo there are some backslashes that taint this patch.
I will resend a V2....
