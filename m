Return-Path: <linux-kernel-owner+w=401wt.eu-S966767AbXEGUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966767AbXEGUnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966517AbXEGUnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:43:17 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:21867 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbXEGUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KDr3Dr4b8feQse8tzESN7ZR0vG6pjPEZItEfhKK09XCSBUUUTVCngbZuaosoNmmkozNUDiBuriKYfI8lgU41+MGHUNUmAXL6AmGxw8CbAOD1Qn1ZAVs7Dtc9yogpwol54jY7jkj+W34rL8ru+6mqCVzYlsVmOvbbTw3TfKU/zkM=
Message-ID: <4d8e3fd30705071343g221c75a8x737b8498c947fdef@mail.gmail.com>
Date: Mon, 7 May 2007 22:43:14 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v10
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Willy Tarreau" <w@1wt.eu>, "Gene Heskett" <gene.heskett@gmail.com>,
       "Mark Lord" <lkml@rtr.ca>
In-Reply-To: <20070507163342.GA3502@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070507163342.GA3502@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> i'm pleased to announce release -v10 of the CFS scheduler patchset.
> (The main goal of CFS is to implement "desktop scheduling" with as
>  high quality as technically possible.)
>
> The CFS patch against v2.6.21.1 (or against v2.6.20.10) can be
> downloaded from the usual place:
>
>     http://people.redhat.com/mingo/cfs-scheduler/
>
> -v10 got a bit bigger than usual. One reason for that is that i couldnt
> resist the fine enhancements contributed by Peter Williams and Mike
> Galbraith. Peter fixed and improved nice level support and SMP
> load-balancing, while Mike applied his "no compromises" interactivity
> tuning skills to CFS:
>
>     6 files changed, 247 insertions(+), 110 deletions(-)
>
> the main user-visible change should be that CFS's 3D gaming performance
> and 'smoothness' should be significantly improved in -v10. This was the
> main remaining regression reported for -v9 (and for CFS in general).

Ciao Ingo,
care to share some more information regarding how you fixed the "3D
gaming performance" issue?

Thanks!

Regards,
                 Paolo
