Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYIVMiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYIVMiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYIVMiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:38:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:48275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYIVMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m0GwbHR18WFguxoVGSDYF5GdVfMuWplEmfifnpxMJGA3Hy6VrJrNujQVLehl8o6+Vr
         67bsurGad83K9svO6Zx5s5Y80IPMRE7ygkTbDAAj67jhxCQ9ywGz9gbmMmuT8nT707OC
         2sxc0jbn8lETMz6oGBfD5mfVlPDY+SGvFP4qc=
Message-ID: <961aa3350809220538u5663ed51y38395f6c07169336@mail.gmail.com>
Date: Mon, 22 Sep 2008 21:38:07 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: check for ioremap() failure in copy_oldmem_page()
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080922101547.GB27526@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080921142711.GB8790@localhost.localdomain>
	 <20080922101547.GB27526@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/22 Ingo Molnar <mingo@elte.hu>:
>
> * Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> Add a check for ioremap() failure in copy_oldmem_page().
>> This patch also includes small coding style fixes.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>
> applied to tip/x86/crashdump, thanks!
>
> I'm curious, have you found this bug via the fault-injection framework,
> or via code review?

I found it via code review.
But I forgot why I was looking at crash_dump_64.c...
