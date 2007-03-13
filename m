Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXCMCXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXCMCXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 22:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXCMCXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 22:23:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16490 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXCMCXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 22:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UYHMiALZWGzsydG4HZ+BafoPoqhdRD2vgv69z9K8f6/MxQJi+1x4pTFOtp31gkFwVk1dl6hdXtzkH80vY0n20OOorpdiqW4UFxq5cAQ0u5Ambm4z87VLVJX9PA0PuZoyovjrYSLCMtKrNZ4xtR5rzbwGKjimGJlUIPNC6P0wg4I=
Message-ID: <75b66ecd0703121923q2f9913cdm8179122d95015ad8@mail.gmail.com>
Date: Mon, 12 Mar 2007 22:23:37 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "David Lang" <david.lang@digitalinsight.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Cc: "Mike Galbraith" <efault@gmx.de>, "Con Kolivas" <kernel@kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.63.0703121523220.1245@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
	 <1173732344.6431.54.camel@Homer.simpson.net>
	 <Pine.LNX.4.63.0703121523220.1245@qynat.qvtvafvgr.pbz>
X-Google-Sender-Auth: cbe4aa2ba73bb9f9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, David Lang <david.lang@digitalinsight.com> wrote:
> the problem comes when this isn't enough. if you have several CPU hogs on a
> system, and they are all around the same priority level, how can the scheduler
> know which one needs the CPU the most for good interactivity?
>
> in some cases you may be able to directly detect that your high-priority process
> is waiting for another one (tracing pipes and local sockets for example), but
> what if you are waiting for several of them? (think a multimedia desktop waiting
> for the sound card, CDRom, hard drive, and video all at once) which one needs
> the extra CPU the most?

I'm not an expert in this area by any means but after reading this
thread the OSX solution of simply telling the kernel "I'm the GUI,
schedule me accordingly" looks increasingly attractive.  Why make the
kernel guess when we can just be explicit?

Does anyone know of a UNIX-like system that has managed to solve this
problem without hooking the GUI into the scheduler?

Lee
