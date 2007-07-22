Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXGVCbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXGVCbE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbXGVCan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:30:43 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:34021 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759486AbXGVCam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YvYg3AzINBvO1eSIxy7CWv17/RVTYaxOK12kj6V1C5DL6S4md7j8JBPNPDQBY4UojdHeABqLtTOjpTcHrT1cAcZxQCJbnXgk/ZH+J577p10MmcI4gygzVPNEJIMI00YHQAy8XPh6Hs4QCCtzaTB/oSGahJrEU+yic7J8D9VqCV4=
Message-ID: <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
Date: Sun, 22 Jul 2007 08:00:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [00/37] Clean up duplicate includes
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200707211701.23911.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211701.23911.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> [...]
> These are the patches in this series :

Ok, I've reviewed all patches in this series except:

>  [PATCH][12/37] Clean up duplicate includes in drivers/net/
>  [PATCH][28/37] Clean up duplicate includes in net/ipv4/
>  [PATCH][32/37] Clean up duplicate includes in net/sunrpc/

which I did not find anywhere ... not even on netdev@

Anyway, the entire series was OK, just removing a #include
line when that exact same header was already #include'd in
the same file. [ I also wonder if this patchset ends up exposing
some header-include-ordering problems that were previously
hidden, actually. ]

> Please consider applying these patches.

I think these are trivial and obvious enough -- can probably be
merged together into single patch by Andrew and just slammed
into the kernel tree :-)

Thanks,
Satyam
