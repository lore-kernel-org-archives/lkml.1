Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbZJPPmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbZJPPmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761394AbZJPPmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:42:31 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:31047 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761107AbZJPPm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:42:28 -0400
Date: Fri, 16 Oct 2009 08:41:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: build issue #30 for v2.6.32-rc5 :linux/dst.h:520: error:
 dereferencing pointer to incomplete type
Message-Id: <20091016084112.410a93e8.randy.dunlap@oracle.com>
In-Reply-To: <200910161735.08133.toralf.foerster@gmx.de>
References: <200910161735.08133.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AD89436.00AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 17:35:07 +0200 Toralf Förster wrote:

> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   CC [M]  drivers/net/vmxnet3/vmxnet3_drv.o
> In file included from drivers/net/vmxnet3/vmxnet3_int.h:62,
>                  from drivers/net/vmxnet3/vmxnet3_drv.c:27:
> include/linux/dst.h: In function 'dst_bio_to_cmd':
> include/linux/dst.h:520: error: dereferencing pointer to incomplete type
> include/linux/dst.h:520: error: 'BIO_POOL_BITS' undeclared (first use in this function)
> include/linux/dst.h:520: error: (Each undeclared identifier is reported only once
> include/linux/dst.h:520: error: for each function it appears in.)
> include/linux/dst.h:521: error: dereferencing pointer to incomplete type
> include/linux/dst.h:522: error: dereferencing pointer to incomplete type
> include/linux/dst.h:525: error: dereferencing pointer to incomplete type
> make[3]: *** [drivers/net/vmxnet3/vmxnet3_drv.o] Error 1
> make[2]: *** [drivers/net/vmxnet3] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> The build was made with :
> $>make randconfig; make clean; make
> 
> Here's the config:


Hi,
I've already posted a vmxnet3 driver patch for this (yesterday).

---
~Randy
