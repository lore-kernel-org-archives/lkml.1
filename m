Return-Path: <linux-kernel-owner+w=401wt.eu-S1764828AbXGJSpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764828AbXGJSpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759891AbXGJSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:44:52 -0400
Received: from mail.trixing.net ([87.230.125.58]:40559 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbXGJSov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:44:51 -0400
Message-ID: <4693D39A.2040103@l4x.org>
Date: Tue, 10 Jul 2007 20:44:42 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org>	 <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>	 <468C053D.9050302@l4x.org> <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
In-Reply-To: <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 7/4/07, Jan Dittmer <jdi@l4x.org> wrote:
>> Mike Frysinger wrote:
>>> On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
>>>> Bryan Wu wrote:
>>>>> Jie's patch is required because we will release our new Blackfin toolchain.
>>>> So, what is the new toolchain version?
>>>> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:
>>> we'll post new toolchain binaries in a bit
>> Hrm, somehow I don't understand it. On [1] you're
>> talking about gcc 4.1.2 and binutils 2.17 supporting
>> the -mcpu switch. But if you download the 2007R1 RC9
>> toolchain from the Files section of the site (tar.gz)
>> you actually get 4.1.1 without mcpu support. But the
>> version string from gcc indicates 07r1.
>> Care to explain?
> 
> the syntax of the -mcpu option was extended

With the current -elf toolchain from svn (-uclinux toolchain fails to
build) I get the following error:

  CC      fs/binfmt_script.o
  CC      fs/binfmt_elf_fdpic.o
  CC      fs/binfmt_flat.o
fs/binfmt_flat.c: In function ‘decompress_exec’:
fs/binfmt_flat.c:293: warning: label ‘out’ defined but not used
fs/binfmt_flat.c: In function ‘load_flat_file’:
fs/binfmt_flat.c:462: warning: format ‘%x’ expects type ‘unsigned int’,
but argument 3 has type ‘long int’
fs/binfmt_flat.c:462: warning: format ‘%x’ expects type ‘unsigned int’,
but argument 4 has type ‘long int’
fs/binfmt_flat.c:549: warning: passing argument 1 of ‘ksize’ makes
pointer from integer without a cast
fs/binfmt_flat.c:601: warning: passing argument 1 of ‘ksize’ makes
pointer from integer without a cast
fs/binfmt_flat.c:760:50: error: macro "flat_get_addr_from_rp" requires 4
arguments, but only 3 given
fs/binfmt_flat.c:760: error: ‘flat_get_addr_from_rp’ undeclared (first
use in this function)
fs/binfmt_flat.c:760: error: (Each undeclared identifier is reported
only once
fs/binfmt_flat.c:760: error: for each function it appears in.)
make[2]: *** [fs/binfmt_flat.o] Error 1
make[1]: *** [fs] Error 2
make: *** [_all] Error 2

Expected?

Jan
