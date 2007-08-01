Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXHAU2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXHAU2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXHAU2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:28:22 -0400
Received: from waste.org ([66.93.16.53]:44789 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbXHAU2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:28:21 -0400
Date: Wed, 1 Aug 2007 15:28:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Yoann Padioleau <padator@wanadoo.fr>,
       David Howells <dhowells@redhat.com>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
Message-ID: <20070801202815.GL11166@waste.org>
References: <200707270944.LAA17167@ifs.emn.fr> <22618.1185531297@redhat.com> <87lkd29mk9.fsf@wanadoo.fr> <200707272138.23323.rgetz@blackfin.uclinux.org> <8bd0f97a0707271837q5d5f31d9pe342e72ebf9368c1@mail.gmail.com> <46AF255A.4050106@student.ltu.se> <8bd0f97a0708010303j7f443b06lf9d77f6d36816237@mail.gmail.com> <46B062AF.1040907@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B062AF.1040907@student.ltu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 12:38:39PM +0200, Richard Knutsson wrote:
> Mike Frysinger wrote:
> >On 7/31/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> >  
> >>Mike Frysinger wrote:
> >>    
> >>>On 7/27/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> >>>      
> >>>>If there is a definite style or semantic preference that everyone 
> >>>>should live
> >>>>with - does it make sense to put checks in checkpatch.pl to enforce it?
> >>>>        
> >>>checkpatch.pl does not have enough semantic knowledge to know if the
> >>>thing being tested is a pointer ... dont know if the sparse utility
> >>>would be able to pick it out as i'm not familiar with what level that
> >>>thing runs at
> >>>      
> >>Didn't he mean "x == NULL" > "!x"?
> >>    
> >
> >i'm sure i understand your meaning of ">" ... are you saying that "x
> >== NULL" is greater (preferred) to "!x" or are you saying that "x ==
> >NULL" should be changed to "!x" ?
> >  
> If I understood Robin correctly, he suggested that checkpatch.pl would 
> tell to convert "x == NULL" to "!x", if that would be the preferred way.
> >i dont think the former case can be checked by checkpatch.pl, but the
> >latter certainly can ... but i'd be very skeptical you could get the
> >wider LKML audience to sign off one way or the other wrt to "x ==
> >NULL" vs "!x".  you can certainly get people to sign off on "x == 0"
> >being wrong when x is a pointer.
> >  
> I agree!
> BTW, too bad checkpatch.pl does not know the types, since it otherwise 
> could check for the "x [=!]= 0"-thing.

About the only place that if (x != 0) is preferred to if (x) is cases
where the 0 value doesn't semantically correspond to false/off/disabled.
And that's basically thing that return 0 for success and negative errors.

-- 
Mathematics is the supreme nostalgia of our time.
