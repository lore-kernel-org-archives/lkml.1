Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYDRLNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYDRLNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYDRLMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:12:54 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:44982 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751213AbYDRLMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:12:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J3GVXe/IMns4kbR34ykF97rKdS3eTUPCCunwez5UDNbFbgu8bPJkO22CR619RmHlF9xQfK69N4+jkneJFjW3MjaGBFTOYEcvF6rENVGGJlaAM4i89wJ/t4q8X+WOSUgKcN838I60cBH5Q8PWtvYrp93mZzuoE315msDw3BiKkto=  ;
X-YMail-OSG: O6AAF8YVM1k81U58nWJYlPNh3aeeou1bdHkKEg15Q6YHR4qDDQygj1hPZq7zStpROdl5Mmdc51UVVpPP4AHzDw56mTulo1sUI6ph9hfePTEHpKbL5h9EiOKzjpXpUrD13DzVzefy7IqdujktnLg.rIen
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Date: Fri, 18 Apr 2008 21:12:39 +1000
User-Agent: KMail/1.9.5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Nick Piggin" <npiggin@suse.de>
References: <20080416202338.GA6007@elte.hu> <20080417103800.GA27250@elte.hu> <84144f020804170342x7d692e83x2b50ebbccfc4c40b@mail.gmail.com>
In-Reply-To: <84144f020804170342x7d692e83x2b50ebbccfc4c40b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804182112.40732.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008 20:42, Pekka Enberg wrote:
> On Thu, Apr 17, 2008 at 1:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >  > We (still!) have not made the decision whether to proceed with slab or
> >  > slub.  How hard would it be to port kmemcheck into slab?
> >
> >  i think slab is clearly out, unless some catastrophic regression is
> >  found. But Nick's SLQB might replace SLUB ;-)
>
> Hey, we all have our favorite replacements for kmalloc():
>
> http://www.kernel.org/pub/linux/kernel/people/penberg/patches/binalloc/2.6.
>25-rc8/kmalloc-binning
>
> But it seems unrealistic to expect any of them to replace SLUB or SLAB
> in the near future.

Obviously that one won't because it is totally unsuitable to replace
SLAB. It may be a good choice to replace SLOB (if it is found to be
technically better). Just the same as SLQB might replace SLAB if it
is found to be technically better. That's (one main criteria for) how
we merge/decide between things.
