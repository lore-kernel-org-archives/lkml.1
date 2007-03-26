Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbXCZTF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbXCZTF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXCZTF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:05:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57660 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbXCZTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:05:56 -0400
Subject: Re: 2.6.21-rc4-mm1
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, khali@linux-fr.org,
       gregkh@suse.de
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Mar 2007 12:05:56 -0800
Message-Id: <1174939556.16728.11.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/

 # make -j8 modules
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  LD [M]  sound/soundcore.o
  CC [M]  sound/ppc/beep.o
sound/ppc/beep.c: In function ‘snd_pmac_attach_beep’:
sound/ppc/beep.c:224: error: dereferencing pointer to incomplete type
sound/ppc/beep.c:242: error: dereferencing pointer to incomplete type
sound/ppc/beep.c:265: error: dereferencing pointer to incomplete type
sound/ppc/beep.c: In function ‘snd_pmac_detach_beep’:
sound/ppc/beep.c:275: error: dereferencing pointer to incomplete type
make[2]: *** [sound/ppc/beep.o] Error 1
make[1]: *** [sound/ppc] Error 2
make: *** [sound] Error 2
make: *** Waiting for unfinished jobs....


Patch that is causing the problem in -mm:
gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch

sound/ppc/beep.c needs to include <linux/pci.h>

Thanks,
Badari
	

