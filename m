Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbZCYLlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbZCYLlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760435AbZCYLkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:40:49 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59661 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760364AbZCYLkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:40:47 -0400
To: wangchen@cn.fujitsu.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: linux-next-20090324: undefined reference to `__this_fixmap_does_not_exist'
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200903250324.n2P3OwX0098272@www262.sakura.ne.jp>
	<49C9BA02.9070706@cn.fujitsu.com>
	<49C9F0CB.2000807@cn.fujitsu.com>
	<49C9FFEA.7060908@cn.fujitsu.com>
In-Reply-To: <49C9FFEA.7060908@cn.fujitsu.com>
Message-Id: <200903252040.GDG04637.OHtQFLVSMFOJOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 25 Mar 2009 20:40:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Wang Chen wrote:
> Maybe we use different gcc versions.
Yes. I'm using gcc 3.3 .

# gcc --version
gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# make -sj2
arch/x86/mm/built-in.o(.init.text+0x1831): In function `early_ioremap_init':
: undefined reference to `__this_fixmap_does_not_exist'
make: *** [.tmp_vmlinux1] Error 1

> Please try following patch.
After applying that patch, this problem was solved.

Thank you.
