Return-Path: <linux-kernel-owner+w=401wt.eu-S966257AbXDGSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbXDGSic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966264AbXDGSib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:38:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44992 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966255AbXDGSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:38:30 -0400
Date: Sat, 7 Apr 2007 20:39:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] clean up identify_cpu
Message-ID: <20070407183916.GA30811@uranus.ravnborg.org>
References: <20070406224152.556848893@goop.org> <20070406224204.782242327@goop.org> <20070407021401.a993892b.akpm@linux-foundation.org> <4617D2D1.7040202@goop.org> <20070407105947.15128675.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407105947.15128675.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 10:59:47AM -0700, Andrew Morton wrote:
> On Sat, 07 Apr 2007 10:20:17 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> >  I don't have a x86-64 compile environment on
> > hand, so the 64 bits are completely untested
> 
> http://userweb.kernel.org/~akpm/cross-compilers/

Does the alpha toolchain work for you?

For defconfig I get:
  CC      arch/alpha/kernel/core_cia.o
{standard input}: Assembler messages:
{standard input}:351: Error: macro requires $at register while noat in effect
{standard input}:376: Error: macro requires $at register while noat in effect
{standard input}:400: Error: macro requires $at register while noat in effect
{standard input}:419: Error: macro requires $at register while noat in effect
{standard input}:474: Error: macro requires $at register while noat in effect
{standard input}:499: Error: macro requires $at register while noat in effect
{standard input}:523: Error: macro requires $at register while noat in effect
{standard input}:542: Error: macro requires $at register while noat in effect
make[2]: *** [arch/alpha/kernel/core_cia.o] Error 1
make[1]: *** [arch/alpha/kernel] Error 2
make: *** [_all] Error 2

Same happens when I compile the same version direct from Dan's crosstool.

	Sam
