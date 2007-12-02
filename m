Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXLBU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXLBU41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXLBU4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:56:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:33430 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbXLBU4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:56:19 -0500
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>, Kumar Gala <galak@kernel.crashing.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711281051540.11968@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com>
	 <20071127001431.688565525@sgi.com>
	 <F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
	 <Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
	 <18252.34032.207280.742887@cargo.ozlabs.ibm.com>
	 <Pine.LNX.4.64.0711271311370.4590@schroedinger.engr.sgi.com>
	 <18252.54275.429917.929763@cargo.ozlabs.ibm.com>
	 <Pine.LNX.4.64.0711281051540.11968@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 07:55:58 +1100
Message-Id: <1196628958.13230.158.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-28 at 10:54 -0800, Christoph Lameter wrote:
> > As far as I can see, after applying your series of patches, I end up
> > with an unbalanced #ifdef in include/asm-powerpc/percpu.h.  I see 3
> > #ifdef/#ifndef, but only two #endifs.  It needs another #endif after
> > the #endif /* SMP */ to match the #ifdef __powerpc64__.  With that
> > change it looks OK, since 32-bit uses asm-generic/percpu.h for both
> > SMP and UP.
> 
> Ahhh.. Ok. Fixed.
> 
> Do you know where to get a ppc64 crosscompiler? I 
> tried to build gcc for ppc64 but the build failed on x86_64.

Usually, we build biarch... checked if your existing gcc happen to work
with -m64 ?

Ben.


