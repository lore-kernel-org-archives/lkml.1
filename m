Return-Path: <linux-kernel-owner+w=401wt.eu-S937261AbXHHSLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937261AbXHHSLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765018AbXHHSK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:10:56 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:43317 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067AbXHHSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:10:55 -0400
Date: Wed, 8 Aug 2007 14:10:34 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Dave Jones <davej@redhat.com>
cc: jschopp <jschopp@austin.ibm.com>, apw@shadowen.org, rdunlap@xenotime.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Make checkpatch warn about pointless casting of kalloc returns.
In-Reply-To: <20070808180056.GF26440@redhat.com>
Message-ID: <Pine.LNX.4.64.0708081408360.26866@lancer.cnet.absolutedigital.net>
References: <20070808024321.GA6316@redhat.com> <46B9F7C9.9060406@austin.ibm.com>
 <20070808180056.GF26440@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Dave Jones wrote:

>  > I haven't tried it but how about something like:
>  > 
>  > if($rawline =~/\(.*\)\s*k[czm]alloc/){
> 
> Hmm,  could even just drop the check for the '*'
> )[ ]k.. should be good enough.

There is none, both the '*'s are qualifiers :)

>  > which if I got it right should match the typecast with any combination of spacing.
>  > 
>  > > +			WARN("No need to cast return value.\n");
>  > 
>  > Could the warning be more descriptive?  This describes what, but it should also describe 
>  > why; after all if somebody made this error they may not know they why.
> 
> I'm open to suggestions..

Point to or quote from: http://c-faq.com/malloc/mallocnocast.html ?

-- 
Cal Peake

