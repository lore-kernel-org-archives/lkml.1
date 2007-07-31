Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbXGaNQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbXGaNQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763539AbXGaNQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:16:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:29623 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762723AbXGaNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DFV+0xko9V8XTb09nctIJWi8DKHkcYLMNF4vwSp390ruf5Os918w96xIImUA+CiBKHA2aaV+5Y2vBlpv2EuYT/4OiPsSHtOSVGLKkit7NTyyWcSiSyqqOFOEgowqr7R04ASzgZqxyzhaYFjz1geKY0MVguR2bCKKhSNTovMaWfY=
Message-ID: <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
Date: Tue, 31 Jul 2007 23:16:09 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Cc: "Kenneth Prugh" <ken69267@gmail.com>, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731094526.GA16300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <20070729170641.GA26220@elte.hu>
	 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
	 <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
	 <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com>
	 <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com>
	 <20070731094526.GA16300@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> * Kenneth Prugh <ken69267@gmail.com> wrote:
> > CFS generally seemed a lot smoother as the load increased, while SD
> > broke down to a highly unstable fps count that fluctuated massively
> > around the third loop. Seems like I will stick to CFS for gaming now.

My experience was quite similar.  I noticed after launching the second
loop that the FPS stuck down to 15 for about 20 seconds, then climbed
back up to 48.  After that it went rapidly downhill.  This is similar
to other benchmarks I've done of SD versus CFS in the past.  At a
"normal" load they're fairly similar but SD breaks down under
pressure.
The only other thing of interest is that the -ck kernel had the WM
menus appear in about 3 seconds rather than 5-8 under the other two.

Game: Nexuiz 2.3
OpenGL 2.0 shaders on
Vertex Buffer Objects on
Show FPS on
ultimate quality
1024x768

2.6.23-git
0 48
1 48
2 48
3 48
4 40
5 38
6 33
7 28
8 22
9 22
10 18

2.6.22.1-ck
0 48
1 48
2 48
3 12
4 6
5 6
6 5
7 4
8 3
9 3
10 2

2.6.22.1-cfs-v19.1+ckbits [*]
0 48
1 48
2 48
3 46
4 45
5 43
6 36
7 32
8 25
9 24
10 24

[*] This kernel has the cfq-* and mm-* patches from -ck applied, and
the above-background-load function from pre-SD ck patchsets (or
2.6.23-git)

-- 
Matt
