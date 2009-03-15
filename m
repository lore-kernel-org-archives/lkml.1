Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZCOEDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZCOEDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZCOEDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:03:32 -0400
Received: from phunq.net ([64.81.85.152]:52666 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750819AbZCOEDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:03:31 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 21:02:56 -0700
User-Agent: KMail/1.9.9
Cc: tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903112238.55864.phillips@phunq.net> <aday6vaqwtk.fsf@cisco.com>
In-Reply-To: <aday6vaqwtk.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142102.56602.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Roland Dreier wrote:
>  > By the way, the endian comment in bitmap.c needs some loving:
>  > 
>  >    http://lxr.linux.no/linux+v2.6.28.7/lib/bitmap.c#L35
>  > 
>  > The s390 file needs to be config-independent:
>  > 
>  > -	include/asm-s390/bitops.h
>  > +	arch/s390/include/asm/bitops.h
>  > 
>  > and the ppc file is nowhere to be seen.  I will put a driveby patch on
>  > the to.do list.
> 
> The ppc file is arch/powerpc/include/asm/bitops.h.

Ah right, so the commentary should just reference arch/ instead of
/..asm-<arch>.  I am still hoping to hear an actual argument why little
endian bitops are "more natural" than big endian.  I don't know of any
myself, either in terms of machine instructions, cycle times or
whatever.

Regards,

Daniel
