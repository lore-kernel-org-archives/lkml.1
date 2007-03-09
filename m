Return-Path: <linux-kernel-owner+w=401wt.eu-S1767588AbXCIWud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767588AbXCIWud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767591AbXCIWud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:50:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:13395 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767588AbXCIWuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:50:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Rx+0vNjjnWLkgIeKekbI0d27ZBEFO2xCCoH4TmN4VcWAtS0elbeifM340znbb6gBfB6k7JhB1rbSFiZhr7kOj1S2IyfnZ4m03Wr5Aoqp8MGvNC4QK9rOmTSZwzXS7tHzUP3/MPJYBK7gFUtCKzEjkKkG/XhzClQLvdrUqTEz1ew=
Message-ID: <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com>
Date: Fri, 9 Mar 2007 17:50:29 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070309180230.GA17988@elte.hu>
	 <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
	 <20070309192420.GA27747@elte.hu>
	 <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr>
X-Google-Sender-Auth: 4d0c408b58f8b26f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> I think the sound example to the right really shows it. /dev/dsp has a
> consistent ABI on a ton of systems. The API below it, varies. Linux got
> file_operations and ALSA. Solaris/BSD may have its
> vnode-and-so-on-functions and some sort of OSS.

I think this is a poor example as applications lose a lot of
functionality (multiple stream mixing, software volume control, etc)
by going through the legacy /dev/dsp interface vs. using native ALSA.

Lee
