Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbXEPKSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbXEPKSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 06:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbXEPKSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 06:18:46 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1988 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbXEPKSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 06:18:45 -0400
Message-ID: <464ADA5D.8050405@shadowen.org>
Date: Wed, 16 May 2007 11:18:05 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting this on both x86 and x86_64 boxes, they are the older boxen so
likely older compilers:

  CC      arch/x86_64/boot/memory.o
arch/i386/boot/memory.c: In function `detect_memory':
arch/i386/boot/memory.c:32: error: can't find a register in class `DREG'
while reloading `asm'

Seems to come from git-netsetup, but that tree isn't pulled into your
git version of -mm so I can't be more specific.

-apw
