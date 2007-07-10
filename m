Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbXGJJWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbXGJJWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbXGJJV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:21:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:6723 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbXGJJV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YXDY69me3PmapDQf7HRBi/O4+3E9QF2qaG6Us0se8e2ZSEvEkDTSJ7+0pYhKOc1k2HYKv1Mu9vNAM85ECz8tw8ew1GGLdrSJTmSh86ffHSFmwQ1i6T0QzuoItM74dvJJKRcH4NlqHnwm/DxRoyJLffKT9hcdG8D5FzXrVbXEWxs=
Message-ID: <1defaf580707100221m32dc22a9u4ec9155d56a3d1c7@mail.gmail.com>
Date: Tue, 10 Jul 2007 11:21:55 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Cc: "Matt Mackall" <mpm@selenic.com>, "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Erik Andersen" <andersen@codepoet.org>
In-Reply-To: <46934D29.40308@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070708075119.GA16631@elte.hu>
	 <20070709095116.c2ea700f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
	 <4692E44E.6000606@yahoo.com.au>
	 <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
	 <4692E8B5.3030404@yahoo.com.au>
	 <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
	 <20070710083212.GG11115@waste.org>
	 <1defaf580707100201y3c2d21c5lc38165eedaa9be73@mail.gmail.com>
	 <46934D29.40308@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Håvard Skinnemoen wrote:
> > On 7/10/07, Matt Mackall <mpm@selenic.com> wrote:
> >
> >> The only remaining known bug is arguably a problem in nommu that SLOB
> >> shouldn't be papering over.
> >
> >
> > I've got another one for you: SLOB ignores ARCH_KMALLOC_MINALIGN so
> > using SLOB in combination with DMA and non-coherent architectures
> > causes data corruption.
>
> Should be fixed in mm, I believe: slob-improved-alignment-handling.patch

Indeed. Thanks, I'll give it a try later today.

Håvard
