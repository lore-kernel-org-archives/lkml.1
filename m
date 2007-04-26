Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbXDZN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbXDZN1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXDZN1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:27:39 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:36725 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbXDZN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:27:39 -0400
Date: Thu, 26 Apr 2007 14:27:36 +0100
To: ak@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error
Message-ID: <20070426132736.GA16909@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630980D.7010904@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4630980D.7010904@shadowen.org>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 13:16), Andy Whitcroft didst pronounce:
> Getting the following on an x86_64 numa box:
> 
>   CC      arch/x86_64/vdso/vclock_gettime.o
> arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
> supported in the 32 bit mode
> make[1]: *** [arch/x86_64/vdso/vclock_gettime.o] Error 1
> make: *** [arch/x86_64/vdso] Error 2
> 
> Kernel config here: http://test.kernel.org/abat/85358/build/dotconfig
> 

Hi Andi,

Backing out x86_64-mm-vdso.patch allowed this kernel to build and boot
successful on the machine in question (elm3b6). The backout caused one reject
in Documentation/kernel-parameters but otherwise backed out easily. It's
not super-clear why it fails to build. If you want me to try another patch,
make sure I'm cc'd and I'll give it a spin.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
