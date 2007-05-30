Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXE3FcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXE3FcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXE3FcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:32:07 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:7257 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXE3FcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JwL1TI6hCIluu3X5Si4Uxsk4KZL4ePjBl8MehUEzve7kjlb4l977jRHZGjK3pN7gOEbzitVBeTJXNRU2sNsma2GLrlOkq8Qen4FW4CkDVVKNTxY0zsBuL5FSSC/SHNoUYSPirOvG9ESflhQfiNmC+XRWQtz5BSLZdB9BG+5xsCg=
Message-ID: <4cefeab80705292231g4c166cd8xd920f2721cbb9c0e@mail.gmail.com>
Date: Wed, 30 May 2007 11:01:59 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <20070529212625.GS3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
	 <200705281049.48679.dhazelton@enter.net>
	 <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
	 <20070528154346.GO3899@stusta.de>
	 <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
	 <20070528171115.GQ3899@stusta.de>
	 <Pine.LNX.4.61.0705292307320.11140@yvahk01.tjqt.qr>
	 <20070529212625.GS3899@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Tue, May 29, 2007 at 11:10:05PM +0200, Jan Engelhardt wrote:
> >
> > On May 28 2007 19:11, Adrian Bunk wrote:
> You completely miss the point of my question.
>
> It's about the performance improvements of the modified code that were
> mentioned.
>
> What you are talking about shouldn't have any effect on the generated
> code.
>

After Daniel refined this testing program, we can see that perf gain
is < 2% which can surely be accounted to cleanups like unnecessary
castings in tight loops.

Again, all the original code has been retained _as-is_. Whatever was
changed, has been mentioned in that detailed changelog that I post
along with patch.

If someone want to review these 500 lines with this changelog in hand,
it should not take more than couple of hours. If no-one can see any
problem in code by now and considering that it's tested on x86(_32),
amd64, ppc and giving somewhat better perf. than original then I
believe it is unnecessarily hanging outside of -mm tree.

I also contacted author (Markus Oberhumer) regarding above changes but
he seems not be responding right now. But still, if it gets into -mm
and gets used by various related projects then it should be good
enough for mainline also.


Cheers,
Nitin
