Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbXGCOKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbXGCOKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXGCOKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:10:09 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:63184 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbXGCOKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:10:08 -0400
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 10:10:07 EDT
Message-ID: <468A560A.9050801@l4x.org>
Date: Tue, 03 Jul 2007 15:58:34 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070628)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
References: <1183423041.10353.8.camel@roc-laptop>
In-Reply-To: <1183423041.10353.8.camel@roc-laptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> Hi Linus:
> 
> Marco's patch will kill the zero file git-pull error.
> Jie's patch is required because we will release our new Blackfin toolchain.

So, what is the new toolchain version?
gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:

bf533-stamp_defconfig [1]:
   CC      arch/blackfin/kernel/asm-offsets.s
cc1: error: unrecognized command line option "-mcpu=bf533-0.3"
make[2]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [_all] Error 2

bf561-ezkit_defconfig [2]:
   CC      arch/blackfin/kernel/asm-offsets.s
cc1: error: unrecognized command line option "-mcpu=bf561-0.3"
make[2]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [_all] Error 2

previously, there was only this error (defconfig) [3]:
CC      fs/binfmt_flat.o
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c: In function ‘decompress_exec’:
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:293: warning: label ‘out’ defined 
but not used
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c: In function ‘load_flat_file’:
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:462: warning: format ‘%x’ expects 
type ‘unsigned int’, but argument 3 has type ‘long int’
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:462: warning: format ‘%x’ expects 
type ‘unsigned int’, but argument 4 has type ‘long int’
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:549: warning: passing argument 1 
of ‘ksize’ makes pointer from integer without a cast
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:601: warning: passing argument 1 
of ‘ksize’ makes pointer from integer without a cast
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:760:50: error: macro 
"flat_get_addr_from_rp" requires 4 arguments, but only 3 given
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:760: error: 
‘flat_get_addr_from_rp’ undeclared (first use in this function)
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:760: error: (Each undeclared 
identifier is reported only once
/tmp/tmp.RAuANA4724/kernel/fs/binfmt_flat.c:760: error: for each function it 
appears in.)
make[2]: *** [fs/binfmt_flat.o] Error 1
make[1]: *** [fs] Error 2
make: *** [_all] Error 2

Thanks,

Jan

[1] http://l4x.org/k/?d=31517
[2] http://l4x.org/k/?d=31518
[3] http://l4x.org/k/?d=31478
