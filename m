Return-Path: <linux-kernel-owner+w=401wt.eu-S1761511AbYFDSfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511AbYFDSfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYFDSey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:34:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:41349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYFDSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jbu7SYwiIdcSHZU4Wa7PXKov8zDRpXQWc6Bz8cwgYtBGH0UvhQlFmLgkt/Nyt4Oq7o
         +/zyKUPgsM9Y+AzmZZW4XvBod5id3D0pc3fCs6snVz/cJJ1n4IqTuGLDrP6JmPzLgErl
         idpSnR98adquXJH4SQ3gJu5PtnV9NHCZUq1Ws=
Date: Wed, 4 Jun 2008 20:34:32 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
Message-ID: <20080604183432.GC27768@mx.loc>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604103353.GC27335@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:33:53PM +0300, Adrian Bunk wrote:

>My gut feeling is that the influence of this kind of linux-tiny patches 
>is hardly noticably compared to the overall code size development, but 
>if you have numbers that prove me wrong just point me to them and I'll 
>stand corrected.
>
>cu
>Adrian
>
>BTW: I'm not insisting on "between 2.6.16 and 2.6.26", that's just some
>     timeframe big enough for showing general trends.

Current kernels are too big, they tend to be about 1MB (ignoring lzma or
gz compression), a couple of years back an ide- and network-enabled
kernel with 8139too (or whatever -nic you use in qemu nowadays) was at
least 30% smaller.
