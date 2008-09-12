Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYILURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYILURl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYILURb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:17:31 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34344 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYILUR3 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ruMPOs9csek6SdSWbZdyxIVN+otVSNyixY6bUjy4gi3ex5O3nqCFHGiGaUFJU3F5z1
         x65krXL0s64qnlPFPFF8TaQpaN0bfLsRvy4V71OoYffAJWngGVr4noK+qbt3un3zrri4
         mS8Bv5z/ZfBhyFFkTJC7TqGoiMTqLDhc3ssmY=
Message-ID: <6934efce0809121317r418c80e8s4755669cc74975c4@mail.gmail.com>
Date: Fri, 12 Sep 2008 13:17:28 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Greg Ungerer" <gerg@snapgear.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080822183713.GC24179@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>
	 <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
	 <48AE0476.80109@snapgear.com> <20080822181314.GB24179@shareable.org>
	 <6934efce0808221116w76a662b0t954b0922b69d3232@mail.gmail.com>
	 <20080822183713.GC24179@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the "fast" in "fast synchronous" gives it away :-)

Yes, I suppose it does.

> I'm using Spansion MirrorBit S29GL128N, which reads at about 0.6 MByte/s.

I think you should get more like an order of magnitude higher.... Get
an expert to look at your timings in the bootloader.  Make sure things
are cached too.  ioremap_cached()...

> Not because they're good, but because that's what the board I'm coding
> for has on it.  I presume they were cheap and familiar to the board
> designers.  (There is 32MB of RAM to play with after all.)
>
> So start a sequence of Busybox processes from a shell script is noticable,
> if it reads from NOR each time.
>
> Oh, and it's a 166MHz ARM, so it's quite capable of decompressing
> faster than the NOR can deliver.

Depends on how you are measuring it.   You ought to be able to get at
least 2 orders of magnitude higher read speeds with a good sync Flash.
 Some of the newer stuff is even faster.
