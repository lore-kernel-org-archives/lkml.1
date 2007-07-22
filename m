Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXGVGiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXGVGiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXGVGiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:38:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:47331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbXGVGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Al31/iDiYKWLjpmsmUZTr+PH+tVdCFIlbwVU1MrTZ4px2OkIdissRdgt3LJItsBLRcdoQyI+ExGV0LH0paSxhPWQZvzL+NdkROGiLUI2AUCLYoa8owDuktMuorV2tYNutjhGHlk41zYm20uPh51d2hs8mu1/EVVH6gvzT09M8sU=
Message-ID: <a781481a0707212338q75995340w8e0d352bce4f3f6a@mail.gmail.com>
Date: Sun, 22 Jul 2007 12:08:06 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [00/37] Clean up duplicate includes
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211701.23911.jesper.juhl@gmail.com>
	 <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > [...]
> > These are the patches in this series :
>
> Ok, I've reviewed all patches in this series except:
>
> >  [PATCH][12/37] Clean up duplicate includes in drivers/net/
> >  [PATCH][28/37] Clean up duplicate includes in net/ipv4/
> >  [PATCH][32/37] Clean up duplicate includes in net/sunrpc/

And I also looked over these three after your resends.

> Anyway, the entire series was OK, just removing a #include
> line when that exact same header was already #include'd in
> the same file. [ I also wonder if this patchset ends up exposing
> some header-include-ordering problems that were previously
> hidden, actually. ]

Like you said you built an allmodconfig, everything should be OK.
[ Except for modules that didn't get included in allmodconfig because
your arch might not have supported it -- but even then, your patches
are obviously correct and will only expose issues elsewhere if we do
see any build breakage, but which isn't likely in any case. ]

So the entire series is reviewed and looks good to me :-)

Thanks,
Satyam
