Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXIYUAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXIYUAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXIYUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:00:33 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56972 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbXIYUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:00:32 -0400
Message-ID: <46F968C2.7080900@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2007 01:30:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kamezawa.hiroyu@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 - powerpc memory hotplug link failure
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.23-rc8-mm1 kernel linking fails on the powerpc (P5+) box

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `memory_block_action':
/root/scrap/linux-2.6.23-rc8/drivers/base/memory.c:188: undefined reference to `.remove_memory'
make: *** [.tmp_vmlinux1] Error 1

# gcc -v
Using built-in specs.
Target: powerpc64-suse-linux
Configured with: ../configure --enable-threads=posix --prefix=/usr 
--with-local-prefix=/usr/local --infodir=/usr/share/info 
--mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib 
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada 
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.1.2 
--enable-ssp --disable-libssp --disable-libgcj --with-slibdir=/lib 
--with-system-zlib --enable-shared --enable-__cxa_atexit 
--enable-libstdcxx-allocator=new --program-suffix=-4.1 
--enable-version-specific-runtime-libs --without-system-libunwind 
--with-cpu=default32 --enable-secureplt --with-long-double-128 --host=powerpc64-suse-linux
Thread model: posix
gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)

 # ld -v
GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
