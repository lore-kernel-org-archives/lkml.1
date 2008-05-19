Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbYESReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbYESReS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYESReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:34:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13510 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbYESRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:33:58 -0400
Date: Mon, 19 May 2008 10:26:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD_FAILURE] linux-next: Tree for May 19 - build fails on
 cryptd_alloc_hash ()
Message-Id: <20080519102627.997d61ef.randy.dunlap@oracle.com>
In-Reply-To: <4831B3F6.5080101@linux.vnet.ibm.com>
References: <20080519174120.2083ea57.sfr@canb.auug.org.au>
	<4831B3F6.5080101@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 22:38:06 +0530 Kamalesh Babulal wrote:

> Hi,
> 
> The next-20080519 kernel build fails on the x86_64 machine, when compiled 
> with the randconfig.
> 
>   LD      .tmp_vmlinux1
> crypto/built-in.o: In function `cryptd_alloc_hash':
> /root/kernels/linux-2.6.26-rc3/crypto/cryptd.c:485: undefined reference to `crypto_ahash_type'
> make: *** [.tmp_vmlinux1] Error 1

Fixed on Thu May 15:  http://lkml.org/lkml/2008/5/15/433
and Herbert says that he merged it on Fri May 16,
so why did it miss being in linux-next on Mon May 19?

Wrong tree/branch/whatever?

---
~Randy
