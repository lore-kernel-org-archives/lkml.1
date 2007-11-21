Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXKUJIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXKUJIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXKUJIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:08:23 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:57603 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXKUJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:08:21 -0500
Date: Wed, 21 Nov 2007 04:06:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Avi Kivity <avi@qumranet.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
In-Reply-To: <20071121010409.27fbbc56.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711210403470.27148@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org> <4743EF47.5000203@linux.vnet.ibm.com> <4743EFF8.9010307@qumranet.com> <alpine.LFD.0.9999.0711210350050.10132@localhost.localdomain>
 <20071121010409.27fbbc56.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Andrew Morton wrote:

> On Wed, 21 Nov 2007 03:52:08 -0500 (EST) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
... snip ...
> > i'm sure i'm going to humiliate myself for asking this, but shouldn't
> > i be able to reproduce the above by just running:
> >
> >   $ make ARCH=powerpc headers_install/headers_check
> >
> > we've sort of had this discussion before where, IIRC, you should be
> > able to generate the appropriate arch-specific headers without having
> > the corresponding toolchain, no?  so why can't i reproduce that error
> > on my x86 box?
> >
>
> I can.
>
> setenv ARCH powerpc
> make mrproper
> make allmodconfig
> make headers_check

ack.  never mind, i just noticed that this is with the rc3-mm1 tree.
i was confused since, in the latest git tree, there is absolutely *no*
inclusion of <asm/kvm.h> anywhere in the tree, so clearly something
like that has been added in the mm tree.

sorry for the noise.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
