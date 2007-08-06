Return-Path: <linux-kernel-owner+w=401wt.eu-S1765046AbXHFTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765046AbXHFTKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbXHFTKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:10:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:37500 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbXHFTKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:10:15 -0400
In-Reply-To: <200708011002.30962.m.kozlowski@tuxland.pl>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708011002.30962.m.kozlowski@tuxland.pl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <76e360562cd5b50bcd991026e5bead55@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-usb-devel@lists.sourceforge.net
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.23-rc1-mm2
Date: Mon, 6 Aug 2007 21:08:56 +0200
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Second issue as reported earilier allmodconfig fails to build on imac 
> g3.
>
>   CC      arch/powerpc/kernel/lparmap.s
>   AS      arch/powerpc/kernel/head_64.o
> lparmap.c: Assembler messages:
> lparmap.c:84: Error: file number 1 already allocated
> make[1]: *** [arch/powerpc/kernel/head_64.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

Please send me the full output of:

gcc --version    (or whatever your gcc is called)
ld --version
ld --help        (I know no better way to get the supported binutils
                   targets, and the default target)

and the lparmap.s file.  You might want to skip sending it
to the lists, it will be a bit big (and off-topic on most
of those lists, anyway).


Segher

