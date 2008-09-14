Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYINJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYINJS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYINJSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:18:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:61032 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYINJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MP0pXa1tEWnqrUaJD7grwyxemUOhpIQaAz+VkoGW8ASQCwQNL/gMOuNOzM09NyvjF/
         uERj6cxrdMg+fTFJzN+iHaHqf4xm0L+YWupA2CHp5AZZtFwOFaV1AqiIH5pavOlKFaRl
         LMq4TrB8myJli6afru3RcH5EPeuhsUBtx4vLQ=
Message-ID: <b647ffbd0809140218v567843d8kb455499c9be34225@mail.gmail.com>
Date: Sun, 14 Sep 2008 11:18:16 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [x86-tip, patch] rework of the microcode splitup
Cc: "Peter Oruba" <peter.oruba@amd.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1221383648.6184.28.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221383648.6184.28.camel@earth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ forgot to add my SOB line ]

>
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: x86-microcode, rework of the microcode splitup
>
> x86, microcode rework, v2
>
> this is a rework of the microcode splitup in tip/x86/microcode
>
> This new interface is supposed to be cleaner and better maintainability-wise;
>
> 4 files changed, 304 insertions(+), 362 deletions(-)

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


>
>
> --- a/arch/x86/kernel/microcode.c
> +++ b/arch/x86/kernel/microcode.c
> @@ -70,8 +70,9 @@
>  *             Fix sigmatch() macro to handle old CPUs with pf == 0.
>  *             Thanks to Stuart Swales for pointing out this bug.
>  */
> -

[ ... ]


-- 
Best regards,
Dmitry Adamushko
