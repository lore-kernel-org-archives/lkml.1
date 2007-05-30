Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXE3PXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXE3PXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXE3PWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:22:50 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:3409 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbXE3PWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AbqK5ESshic40LykmI+RTFP8Pf5wPobKMR//9jz4jfgxMQQf4koKO/TR5CHEhlOkh2ZJD6vGx0Z0MFhCwaTBCvXUHJd2RQmvE/pKb0JCxqURAVBKUdqktqgZWFGWAegcvaRFyslEqYNmSqwt5ihv1OlMlHru2odhMzq3rLtet0M=
Message-ID: <2bd9ebfa0705300822s453fe5ccva18bf244e1551098@mail.gmail.com>
Date: Wed, 30 May 2007 20:52:29 +0530
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: Linux-kernel-digest Digest, Vol 32, Issue 795
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070530151209.GA15335@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mailman.13746.1180510421.20629.linux-kernel-digest@lists.us.dell.com>
	 <2bd9ebfa0705300735l51dcf4ceubf7f83ab44703010@mail.gmail.com>
	 <2bd9ebfa0705300737t4f11ee71mca114b37a969db01@mail.gmail.com>
	 <20070530151209.GA15335@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, May 30, 2007 at 08:07:53PM +0530, Tej Parkash wrote:
> > On 5/30/07, Tej Parkash <tejparkash.d@gmail.com> wrote:
> > >> > >
> > >> > > while building module i was getting following warning and it
> > >terminate
> > >> > > module building stage
> > >> > The below are only warnings and your build should succeed.
> > >> >
> > >> > It is obviously i386 - is it a clean allmodconfig or any changes?
> > >> > Is it latest -linus or some older version of the codebase?
> > >> Did an allmodconfig build of i386 - I see (almost) all warnings here.
> > >> So I will take a look based on this.
> >
> > yaa i got the warning but as i said building stage is also getting
> > terminated, without any error.
> >
> > >The MODPOST stage took a while but it proceeded with no hick-ups.
> > > MDOPSOT deals with ~2000 modules in my case and that consumes a bit
> > > of memory. Maybe you are hitting the limit with respect to available RAM
> > > / SWAP?
> > >
> > >        Sam
> > >
> > >
> > I don't think so that RAM or SWAP space is a constraint, is it related
> > to kernel build option or some change in arch. config files
> > I am not aware of the required patches for the same.
> Can you please post relevant parts of a build with make V=2
> That is the last couple of commands before the build suddenly stops.
> Also to error-code reported by make must be included.
>
> Ohh, and exact command-line + config you use.
>
>         Sam
>

make -C /lib/modules/2.6.21.3/build/ SUBDIR=/home/tej/Offload modules
make[1]: Entering directory `/home/tej/linux_src/linux-2.6.21.3'
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  Building modules, stage 2.
  MODPOST 1889 modules
WARNING: vmlinux - Section mismatch: reference to
.init.text:start_kernel from .text between 'is386' (at offset
0xc0101171) and 'check_x87'
WARNING: vmlinux - Section mismatch: reference to .init.text: from
.text between 'rest_init' (at offset 0xc0101458) and 'try_name'
WARNING: vmlinux - Section mismatch: reference to
.init.text:__alloc_bootmem from .text between 'init_gdt' (at offset
0xc010adfb) and 'cpu_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:__alloc_bootmem from .text between 'init_gdt' (at offset
0xc010ae11) and 'cpu_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:sysenter_setup from .text between 'identify_cpu' (at offset
0xc010b46b) and 'display_cacheinfo'
WARNING: vmlinux - Section mismatch: reference to
.init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset
0xc010b475) and 'display_cacheinfo'
WARNING: vmlinux - Section mismatch: reference to
.init.text:trap_init_f00f_bug from .text between 'init_intel' (at
offset 0xc010d576) and 'cpuid4_cache_lookup'
WARNING: vmlinux - Section mismatch: reference to .init.text: from
.text between 'iret_exc' (at offset 0xc02f2c2e) and '_etext'
WARNING: vmlinux - Section mismatch: reference to
.init.data:initkmem_list3 from .text between 'set_up_list3s' (at
offset 0xc0173aff) and 's_start'
WARNING: vmlinux - Section mismatch: reference to
.init.text:eisa_root_register from .text between
'virtual_eisa_root_init' (at offset 0xc026fecf) and
'cpufreq_unregister_driver'
WARNING: vmlinux - Section mismatch: reference to .init.text: from
.text between 'iret_exc' (at offset 0xc02f32c8) and '_etext'
make[1]: Leaving directory `/home/tej/linux_src/linux-2.6.21.3'


the actaul kernel where i am running this make is in
/home/tej/linux_src/linux-2.6.21.3.

thanks
tej
