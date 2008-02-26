Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbYBZS1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbYBZS1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYBZS0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:26:53 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58922 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYBZS0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:26:51 -0500
Date: Tue, 26 Feb 2008 20:25:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD_FAILURE] Linux 2.6.25-rc3 - various unexported
	functions () on powerpc
Message-ID: <20080226182545.GE8287@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org> <47C42234.6060906@linux.vnet.ibm.com> <20080226151512.GA10717@cs181133002.pp.htv.fi> <47C457F5.4080902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C457F5.4080902@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:48:29PM +0530, Kamalesh Babulal wrote:
> Adrian Bunk wrote:
> > On Tue, Feb 26, 2008 at 07:59:08PM +0530, Kamalesh Babulal wrote:
> >> Hi,
> >>
> >> The 2.6.25-rc3 kernel build fails on powerpc with allyesconfig config option,
> >> the .config has been attached.
> >> ...
> > 
> > Builds fine here.
> > 
> > Local problem (e.g. disk full) on your machine?
> > 
> > cu
> > Adrian
> > 
> Hi Adrain,

Hi Kamalseh,  ;)

> It Builds fine on another powerpc box with the same .config file, the problem seems to be with the gcc
> on that box, the reported build failure might have been the side effect of the same. 
> 
> 
> drivers/md/raid6int8.c: In function `raid6_int8_gen_syndrome':
> drivers/md/raid6int8.c:185: error: unable to find a register to spill in class `FLOAT_REGS'
> drivers/md/raid6int8.c:185: error: this is the insn:
> (insn:HI 619 799 638 4 drivers/md/raid6int8.c:168 (set (mem:DI (plus:DI (reg/v/f:DI 122 [ p ])
>                 (reg/v:DI 66 ctr [orig:124 d ] [124])) [0 S8 A64])
>         (reg/v:DI 129 [ wp0 ])) 320 {*movdi_internal64} (nil)
>     (expr_list:REG_DEAD (reg/v:DI 129 [ wp0 ])
>         (nil)))
> drivers/md/raid6int8.c:185: confused by earlier errors, bailing out
> make[2]: *** [drivers/md/raid6int8.o] Error 1
> make[1]: *** [drivers/md] Error 2
> make: *** [drivers] Error 2
> 
> # gcc --version
> gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-3)

this means your quite old vendor gcc has a bug.

> Thanks & Regards,
> Kamalesh Babulal,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

