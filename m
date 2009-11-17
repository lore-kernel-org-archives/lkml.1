Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZKQR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZKQR7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbZKQR7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:59:08 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56154 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZKQR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Wm+yoZ18Vos5OjP0e1fa1lHTVdC5aC3V8QF1BMoWMU+d7tIJub5p8UtuJddgdIxfGA
         fIfZPbRiV8PE/7Xdz0HrzcehX1nau16C3M7LJ9kfZirsh49yn2Q4Ft+3Q/7IL1FfU+fX
         nJ/bh64xbAVmbAIlU+S17dkIxbrLYY58cmJ4A=
Message-ID: <4B02E300.8080409@gmail.com>
Date: Tue, 17 Nov 2009 18:53:04 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David VomLehn <dvomlehn@cisco.com>, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>	 <4AFC4D31.2000101@gmail.com>	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>	 <20091113091031.3f6d4bba@marrow.netinsight.se>	 <1258112748.21596.1227.camel@localhost> <4AFE6A14.4010507@gmail.com>	 <1258447997.27437.76.camel@localhost>	 <2ea1731b0911170445x13225c19w797388d2211de2d9@mail.gmail.com> <1258463404.27437.103.camel@localhost>
In-Reply-To: <1258463404.27437.103.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Tue, 2009-11-17 at 13:45 +0100, Marco Stornelli wrote:
>> 2009/11/17 Artem Bityutskiy <dedekind1@gmail.com>:
>
> We need to store this information of NAND flash. Implementing logs on
> NAND flash is about handling bad blocks, choosing format of records, and
> may be even handling wear-levelling. This is not that simple.
> 
> And then I have match oops to the userspace environment prints, using I
> guess timestamps, which is also about complications in userspace.
> 

Indeed my suggestion was to use a persistent ram, not difficult to use.

>>> This patch solves the problem gracefully, and I'd rather demand you to point what
>>> is the technical problem with the patches.
>>>
>> Simply because I think that we should avoid to include in the kernel
>> things we can do in a simply way at user space level.
> 
> If it is much easier to have in the kernel, then this argument does not
> work, IMHO.
> 
>>  I think this
>> patch is well done but it's one of the patches that are solutions "for
>> embedded only", but it's only my opinion.
> 
> Also IMHO, but having embedded-only things is not bad at all.
> 

In the past other patches are not accepted in main line for this, maybe
you'll be luckier.

Marco
