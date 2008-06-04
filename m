Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbYFDTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbYFDTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbYFDTWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:22:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:63669 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbYFDTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=muslOE2bCmWoy2A6uBxEV56TdGH28QP0Bk9QjOtIEDZe6w6IOIQjOtLtUr3+XKBJiv
         JgZaOZxogalU3JP0fNINBSw0bYtlNywSxjd38BIO2+L2EUAXXyBKtzU9/XbmG2xmj/J9
         /L8Sy8A9b9+sjRFjzoGBDLQ3omM/THmu90WPQ=
Date: Wed, 4 Jun 2008 21:21:37 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
Message-ID: <20080604192137.GD27768@mx.loc>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <20080604183432.GC27768@mx.loc> <20080604190146.GE4189@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604190146.GE4189@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 10:01:46PM +0300, Adrian Bunk wrote:
>On Wed, Jun 04, 2008 at 08:34:32PM +0200, Bernhard Fischer wrote:
 
>> Current kernels are too big, they tend to be about 1MB (ignoring lzma or
>> gz compression), a couple of years back an ide- and network-enabled
>> kernel with 8139too (or whatever -nic you use in qemu nowadays) was at
>> least 30% smaller.
>
>No disagreement that the kernel could (and should) become smaller for
>situations where the kernel size matters.
>
>My question is only about whether *this kind of patches* is the correct 
>approach.

Every dozend of bytes less helps to some degree. I can boot a smallish
testsystem in qemu with 4MB ram and have a useable userspace in 120k or
up to 1.2MB diskspace to play with.

The kernel ultimately needs the vast majority of resources in such a
system; most of the RAM and most of the diskspace (assuming a
comfortable userspace with 500k). Booting with 2MB didn't work last time
i tried. This imbalance is something we should fix.

So yes, 5k help, several 5k help more. I can see how it's problematic to
represent that in menuconfig without adding too much clutter but still
letting the user decide whether or not to include certain families of
features, but that should not turn out to be a real problem.
