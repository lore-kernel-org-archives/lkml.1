Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYEWW0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYEWW0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYEWW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:26:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbYEWW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:26:08 -0400
Date: Fri, 23 May 2008 15:23:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, oberparleiter@googlemail.com,
       peter.oberparleiter@de.ibm.com, sam@ravnborg.org,
       ltp-coverage@lists.sourceforge.net
Subject: Re: [PATCH 0/7] gcov kernel support
Message-Id: <20080523152311.1dde66a7.akpm@linux-foundation.org>
In-Reply-To: <7b1023f2a9cf769f8bc047c0116be9dd@kernel.crashing.org>
References: <48313D8E.7020109@de.ibm.com>
	<20080523011213.690363c7.akpm@linux-foundation.org>
	<ab1f935148982762bae55734ffb8acc7@kernel.crashing.org>
	<20080523095623.5678a34f.akpm@linux-foundation.org>
	<7b1023f2a9cf769f8bc047c0116be9dd@kernel.crashing.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 23:52:43 +0200
Segher Boessenkool <segher@kernel.crashing.org> wrote:

> >> You *can* build with a non-biarch compiler, but then you need to point
> >> the kernel build system at a 32-bit toolchain to use for the 32-bit
> >> parts (via CROSS32_COMPILE).
> >
> > Jens built this one, using crosstool.  It is
> > http://userweb.kernel.org/~akpm/cross-compilers/power64-cross.tar.bz2
> >
> > It was all working happily until gcov came along :(
> 
> You were lucky, yes.  If your compiler would have been just a little
> bit older it wouldn't have been able to build 32-bit at all.
> 
> Do you have a separate 32-bit PowerPC compiler?

I dont' cross-compile for 32-bit power.  This is all 64-bit stuff.

>  If so, just set
> CROSS32_COMPILE to it; if not, you'll need a new toolchain.  In
> that case, it's probably worthwhile to upgrade to 4.1.2 at least...

Sigh.  Life's too short.  I'll go back to testing powerpc builds on the
powerpc box.

