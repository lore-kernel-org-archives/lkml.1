Return-Path: <linux-kernel-owner+w=401wt.eu-S1766633AbXEBTS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766633AbXEBTS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766637AbXEBTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:18:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:42179 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766633AbXEBTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EtI3TLy3QHcEh4F7PehaGCWdCo6rNUh1sOV5Dcr999PJjqgx/3YmBv0PIMDT5BX9k3Y/G1ayOJn+5pwxcP9MgCVU0E2S+/qhpB8drcZci5UobSH3Y1AdNkeaVEgDE5474HrTwZNPaQj40QMPj/Ssmvi6jwTejaRICapuvYSxE9I=
Message-ID: <84144f020705021218v7ab2461ala215bbb034475e07@mail.gmail.com>
Date: Wed, 2 May 2007 22:18:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: 2.6.22 -mm merge plans: slub
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>, haveblue@ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0705021158150.1220@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <20070501125559.9ab42896.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0705021924200.24456@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0705021137210.1027@schroedinger.engr.sgi.com>
	 <20070502115725.683ac702.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705021158150.1220@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 9b9ca7774d32ff14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Christoph Lameter <clameter@sgi.com> wrote:
> Owww... You throw my roadmap out of the window and may create too
> high expectations of SLUB.

Me too!

On 5/2/07, Christoph Lameter <clameter@sgi.com> wrote:
> I am the one who has to maintain SLAB and SLUB it seems and I have been
> dealing with the trio SLAB, SLOB and SLUB for awhile now. Its okay and it
> will be much easier once the cleanups are in.

And then there's patches such as kmemleak which would need to target
all three. Plus it doesn't really make sense for users to select
between three competiting implementations. Please don't take away our
high hopes of getting rid of mm/slab.c Christoph =)

                                      Pekka
