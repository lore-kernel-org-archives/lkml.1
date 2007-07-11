Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbXGKCDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbXGKCDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXGKCDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:03:15 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23862 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbXGKCDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:03:14 -0400
X-IronPort-AV: i="4.16,524,1175486400"; 
   d="scan'208"; a="45122525:sNHT28042413"
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jan Dittmer <jdi@l4x.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, bryan.wu@analog.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4693D39A.2040103@l4x.org>
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org>
	 <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>
	 <468C053D.9050302@l4x.org>
	 <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
	 <4693D39A.2040103@l4x.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: Analog Devices, Inc.
Date: Wed, 11 Jul 2007 10:09:23 +0800
Message-Id: <1184119763.22259.6.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 11 Jul 2007 02:03:13.0657 (UTC) FILETIME=[A38CC690:01C7C35F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 20:44 +0200, Jan Dittmer wrote:
> Mike Frysinger wrote:
> > On 7/4/07, Jan Dittmer <jdi@l4x.org> wrote:
> >> Mike Frysinger wrote:
> >>> On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
> >>>> Bryan Wu wrote:
> >>>>> Jie's patch is required because we will release our new Blackfin toolchain.
> >>>> So, what is the new toolchain version?
> >>>> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:
> >>> we'll post new toolchain binaries in a bit
> >> Hrm, somehow I don't understand it. On [1] you're
> >> talking about gcc 4.1.2 and binutils 2.17 supporting
> >> the -mcpu switch. But if you download the 2007R1 RC9
> >> toolchain from the Files section of the site (tar.gz)
> >> you actually get 4.1.1 without mcpu support. But the
> >> version string from gcc indicates 07r1.
> >> Care to explain?
> > 
> > the syntax of the -mcpu option was extended
> 
> With the current -elf toolchain from svn (-uclinux toolchain fails to
> build) I get the following error:
> 
>   CC      fs/binfmt_script.o
>   CC      fs/binfmt_elf_fdpic.o
>   CC      fs/binfmt_flat.o
> fs/binfmt_flat.c: In function ‘decompress_exec’:
> fs/binfmt_flat.c:293: warning: label ‘out’ defined but not used
> fs/binfmt_flat.c: In function ‘load_flat_file’:
> fs/binfmt_flat.c:462: warning: format ‘%x’ expects type ‘unsigned int’,
> but argument 3 has type ‘long int’
> fs/binfmt_flat.c:462: warning: format ‘%x’ expects type ‘unsigned int’,
> but argument 4 has type ‘long int’
> fs/binfmt_flat.c:549: warning: passing argument 1 of ‘ksize’ makes
> pointer from integer without a cast
> fs/binfmt_flat.c:601: warning: passing argument 1 of ‘ksize’ makes
> pointer from integer without a cast
> fs/binfmt_flat.c:760:50: error: macro "flat_get_addr_from_rp" requires 4
> arguments, but only 3 given
> fs/binfmt_flat.c:760: error: ‘flat_get_addr_from_rp’ undeclared (first
> use in this function)
> fs/binfmt_flat.c:760: error: (Each undeclared identifier is reported
> only once
> fs/binfmt_flat.c:760: error: for each function it appears in.)
> make[2]: *** [fs/binfmt_flat.o] Error 1
> make[1]: *** [fs] Error 2
> make: *** [_all] Error 2
> 
> Expected?
> 
> Jan

Yes, It should be, because a binfmt_flat patch hacking by blackfin is
not merged by mainline. Please apply the 2 patches in the SVN trunk
uclinux-dist/bfin_patch/lkml_patch/ and you can find the information
about these 2 patches in uclinux-dist/bfin_patch/lkml_patch/README.

Thanks
- Bryan Wu
