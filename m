Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXCZSrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXCZSrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXCZSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:47:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52554 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbXCZSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:47:31 -0400
Subject: Re: 2.6.21-rc4-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, fenkes@de.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, paulus@samba.org,
       benh@kernel.crashing.org
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Mar 2007 11:47:30 -0800
Message-Id: <1174938450.16728.8.camel@dyn9047017100.beaverton.ibm.com>
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
> 


  CC      arch/powerpc/kernel/ibmebus.o
arch/powerpc/kernel/ibmebus.c:463: error: ‘of_device_uevent’ undeclared
here (not in a function)
make[1]: *** [arch/powerpc/kernel/ibmebus.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

Patch causing the problem in -mm:
	ibmebus-uevent-support.patch

I don't see where ‘of_device_uevent’ is defined :(

Thanks,
Badari

