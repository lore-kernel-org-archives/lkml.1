Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXHJDec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXHJDec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 23:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXHJDeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 23:34:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:47398 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbXHJDeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 23:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ccn8wLCPB0aZ3JgJgbwego75y9ylko+3KIu7k+CF7Jd7wLAZj5c7zuiYnJ7G8Fi+cGpZH4CKdWBTc8gfpIQbM/slu9r/veZtSLTy9b8Ts61UFEWMQpoB/gRASWF2MBZQQ5HxUWImmtSYXUMGP2Mb3gHOvkjFmlrWsr8qe97bLOs=
Message-ID: <4a5909270708092034yaa0a583w70084ef93266df48@mail.gmail.com>
Date: Thu, 9 Aug 2007 23:34:20 -0400
From: "Daniel Phillips" <daniel.raymond.phillips@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Phillips" <phillips@google.com>
In-Reply-To: <Pine.LNX.4.64.0708091844450.3185@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806102922.907530000@chello.nl>
	 <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com>
	 <200708061649.56487.phillips@phunq.net>
	 <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
	 <4a5909270708080037n32be2a73k5c28d33bb02f770b@mail.gmail.com>
	 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com>
	 <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com>
	 <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com>
	 <4a5909270708091717n2f93fcb5i284d82edfd235145@mail.gmail.com>
	 <Pine.LNX.4.64.0708091844450.3185@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Christoph Lameter <clameter@sgi.com> wrote:
> The allocations problems that this patch addresses can be fixed by making reclaim
> more intelligent.

If you believe that the deadlock problems we address here can be
better fixed by making reclaim more intelligent then please post a
patch and we will test it.  I am highly skeptical, but the proof is in
the patch.

> If we can reclaim in an emergency even in ATOMIC contexts then things get much
> easier.

It is already easy, and it is already fixed in this patch series.
Sure, we can pare these patches down a little more, but you are going
to have a really hard time coming up with something simpler that
actually works.

Regards,

Daniel
