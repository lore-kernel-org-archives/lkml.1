Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbXGJJLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbXGJJLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXGJJLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:11:14 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40693 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755858AbXGJJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:11:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=hM9XUARY1ah0xgLhmVH/r2n57SKTy7VDwedebCMUfCMaU01nuURAaObg9PIy7VwlLgwf28T82gANTjXdykzzyZhyMnAaVE8lXxTLLwtie+tbWy8VcoN21e11DURPCfH2X5mDHpqs1UO24S76vYn4XmUBkW8OYMeXUhsnsGMiCRg=  ;
X-YMail-OSG: hhfzIEYVM1ld71CJ_ZSPm0.XU25XYtcZl9jfjnS4t0mCXUEustu3BEuZe8vR1N9jXO5iD_MY4A--
Message-ID: <46934D29.40308@yahoo.com.au>
Date: Tue, 10 Jul 2007 19:11:05 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708075119.GA16631@elte.hu> <4691A415.6040208@yahoo.com.au>	 <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>	 <20070709095116.c2ea700f.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>	 <4692E44E.6000606@yahoo.com.au>	 <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>	 <4692E8B5.3030404@yahoo.com.au>	 <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>	 <20070710083212.GG11115@waste.org> <1defaf580707100201y3c2d21c5lc38165eedaa9be73@mail.gmail.com>
In-Reply-To: <1defaf580707100201y3c2d21c5lc38165eedaa9be73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Håvard Skinnemoen wrote:
> On 7/10/07, Matt Mackall <mpm@selenic.com> wrote:
> 
>> The only remaining known bug is arguably a problem in nommu that SLOB
>> shouldn't be papering over.
> 
> 
> I've got another one for you: SLOB ignores ARCH_KMALLOC_MINALIGN so
> using SLOB in combination with DMA and non-coherent architectures
> causes data corruption.

Should be fixed in mm, I believe: slob-improved-alignment-handling.patch

-- 
SUSE Labs, Novell Inc.
