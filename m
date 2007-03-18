Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXCRTHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXCRTHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCRTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:07:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:11981 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbXCRTHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OCldBcv4wxlfPamv6+64vlqi+H2lOyYtw+iRG7wYwUskREZcTkVeD8LQ/PlHk/+evjQxlUtg3DnCjylKuS6qQu6EsCEjiJzjlZyHzYWNMlDoudYaZS41OA6O+eT5kINryQ48uOu7SiFng/SLbB6Z8X3GQVqwpwMC7pkVbMwfNDw=
From: Maxim <maximlevitsky@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [5/6] 2.6.21-rc4: known regressions
Date: Sun, 18 Mar 2007 21:07:01 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184926.GY752@stusta.de>
In-Reply-To: <20070318184926.GY752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703182107.01894.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : i386: APIC timer disabled due to verification failure
>              (once in three boots or so)
> References : http://lkml.org/lkml/2007/3/16/126
> Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Patch      : http://lkml.org/lkml/2007/3/16/420
> Status     : patch available
> 
> 
> 

Hello,

This one is a small issue, I got bigger ones: as I said change in code order in suspend code broke both suspend to ram and disk

Those are commits.
        e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c (breaks  S3)
        ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c (breaks swsusp, I don't use it, but I tested it)
        259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c (breaks uswsusp, that I use)

System freezes before suspend with those commits, even before suspend to disk.

I think that is is not so good idea to tell about all bugs in single letter ;-)

Regards,
	Maxim Levitsky
