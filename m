Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbZALVrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbZALVrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757197AbZALVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:47:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:43481 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040AbZALVrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:47:19 -0500
Subject: Re: [PATCH] powerpc: Fix cpufreq drivers after cpufreq core changes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Olof Johansson <olof@lixom.net>,
       arndb <arndb@arndb.de>
In-Reply-To: <20090112083412.GB19701@elte.hu>
References: <20090112104837.69feedec.sfr@canb.auug.org.au>
	 <1231719015.22571.4.camel@pasglop> <1231719721.22571.9.camel@pasglop>
	 <20090112083412.GB19701@elte.hu>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 08:45:36 +1100
Message-Id: <1231796736.22571.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 09:34 +0100, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > This updates the cpufreq drivers in arch/powerpc so they build again
> > after the core cpufreq changes that broke them in commit
> > in835481d9bcd65720b473db6b38746a74a3964218.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> > Tested on a G5. Olof, Arnd, any chance you can test the cell and pasemi
> > drivers still work ?
> > 
> > Linus, you can probably merge this now to fix the build problems.
> 
> Thanks Ben!
> 
> The powerpc defconfig built fine - you might wan to turn on cpufreq in the 
> powerpc defconfig so that cross-build tests can catch problems like this.

Hrm... which config are you using ? ppc64_defconfig has them all on.

Cheers,
Ben.


