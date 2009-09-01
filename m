Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZIAInH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZIAInH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZIAInG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:43:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:17459 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbZIAInE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rPMWngLd3cYP6k83cFDfJGuI2HVyZbAXkwsgjywn5lvfeM7g1s6YNwyli7rk5twveQ
         72yvF3n15CT2Hun/Tr8YSGx359hJYcOW9Z0voNCq6wApDYZyx5/oWp2ZDkaAPv7djH2O
         vqxuEBylt+bolk5mA7+OH2jZgN0Fg8Ui2UDwM=
MIME-Version: 1.0
In-Reply-To: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>
References: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>
Date: Tue, 1 Sep 2009 12:43:06 +0400
Message-ID: <aa79d98a0909010143t27096d25n1ee36651f8487b52@mail.gmail.com>
Subject: Re: [Question] x86,APIC: In apicdef.h dfr,svr,...... shouldn't be 
	const?
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/09, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> Hello guys, Intel System programmers guide says - dfr, svr, esr - this
> registers should be readonly. So shouldn't they use const? Or is it
> anything else?

Hi Rakib, i dont have sources under my hands at moment, but iirc there
were situations we nees to poke esr register.

>
> And apicdef.h also contains a style problem, checkpatch warns about
> following style:
>
>               u32	spurious_vector	:  8
>
> Check patch wants as:
>
>                          u32	spurious_vector:8
>
> Shouldn't this issues be fixed?
>
> Thanks,
> --

i dont see reason why not ;)
though i wonder why we need this structure at all. We may have
extended amd entries.
Yinghai cced.
