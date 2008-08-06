Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbYHFGEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbYHFGEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYHFGDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:03:55 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:60253 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753735AbYHFGDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:03:54 -0400
Date: Wed, 6 Aug 2008 15:03:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: rsk7203_defconfig build error
Message-ID: <20080806060303.GB2610@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080805154429.GD22895@cs181140183.pp.htv.fi> <87sktjw6sh.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sktjw6sh.wl%ysato@users.sourceforge.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 04:22:54PM -0400, Yoshinori Sato wrote:
> At Tue, 5 Aug 2008 18:44:29 +0300,
> Adrian Bunk wrote:
> > 
> > Hi Paul,
> > 
> > rsk7203_defconfig fails to build with the following error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > arch/sh/kernel/built-in.o:(__ksymtab+0xb8): undefined reference to `__udivsi3_i4i'
> > arch/sh/kernel/built-in.o:(__ksymtab+0xc8): undefined reference to `__sdivsi3_i4i'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > <--  snip  -->
> > 
> > That worked with 2.6.26, and these are far less undefined references 
> > than in the cases where libgcc was missing.
> 
> This functions is not defined sh2 and sh2a.
> See gcc-4.3.1/gcc/config/sh/lib1funcs.asm
> 
> Sorry I forget report.
> 
> This patch not tested.
> Please test and apply.
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
This works fine for my toolchains at least, so I'll apply it.
