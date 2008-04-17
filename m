Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbYDQKmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbYDQKmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbYDQKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:42:41 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:21959 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYDQKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VWjk5k2Owg8KHuevZL+GcjOaGtDExFiMCJ3+9eIzRrptqgUDmQq6Th8P4N04p5EQnHzOKstaCgKuDmZSXGecda0tUH2sRSdklXh3pZFKqvDRm4zoYRE4ApGSOoY1QS0LFyZJsPANAWUogzOo07Hoh6xcBbDVBLsbKsGOatsySV4=
Message-ID: <84144f020804170342x7d692e83x2b50ebbccfc4c40b@mail.gmail.com>
Date: Thu, 17 Apr 2008 13:42:38 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Nick Piggin" <npiggin@suse.de>
In-Reply-To: <20080417103800.GA27250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu> <20080417083000.GA4935@elte.hu>
	 <20080417014054.ea788f1f.akpm@linux-foundation.org>
	 <20080417090626.GA14383@elte.hu>
	 <20080417021813.04df7912.akpm@linux-foundation.org>
	 <20080417093025.GA17389@elte.hu>
	 <20080417023603.672d1032.akpm@linux-foundation.org>
	 <84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com>
	 <20080417033333.947dfcc9.akpm@linux-foundation.org>
	 <20080417103800.GA27250@elte.hu>
X-Google-Sender-Auth: f1280731d55c8d1b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 1:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  > We (still!) have not made the decision whether to proceed with slab or
>  > slub.  How hard would it be to port kmemcheck into slab?
>
>  i think slab is clearly out, unless some catastrophic regression is
>  found. But Nick's SLQB might replace SLUB ;-)

Hey, we all have our favorite replacements for kmalloc():

http://www.kernel.org/pub/linux/kernel/people/penberg/patches/binalloc/2.6.25-rc8/kmalloc-binning

But it seems unrealistic to expect any of them to replace SLUB or SLAB
in the near future.

                             Pekka
