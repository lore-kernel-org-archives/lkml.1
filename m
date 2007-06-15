Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXFOMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXFOMwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXFOMwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:52:30 -0400
Received: from smtp4.libero.it ([193.70.192.54]:52519 "EHLO smtp4.libero.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXFOMw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:52:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAAMpckaXSMuO/2dsb2JhbAAN
Message-ID: <46728BB6.4040704@gmail.com>
Date: Fri, 15 Jun 2007 14:53:10 +0200
From: davide <davidenitti@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070418)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>, Jerome Glisse <j.glisse@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Random X lockup
References: <4671AF64.9050201@gmail.com> <9a8748490706141552l6d112c16tc306784664c6504d@mail.gmail.com>
In-Reply-To: <9a8748490706141552l6d112c16tc306784664c6504d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for answers,

I have radeon 9700, using ati closed drivers, i will try open drivers
I watched all logs and I didn't find any error connected to my problem.

I tried to debug X process using gdb:

delta:~ # gdb X 4351
[...]
Attaching to program: /usr/bin/X, process 4351
Reading symbols from /lib/libdl.so.2...done.
Loaded symbols for /lib/libdl.so.2
Reading symbols from /usr/lib/libXfont.so.1...done.
Loaded symbols for /usr/lib/libXfont.so.1
Reading symbols from /usr/lib/libfreetype.so.6...done.
Loaded symbols for /usr/lib/libfreetype.so.6
Reading symbols from /usr/lib/libXau.so.6...done.
Loaded symbols for /usr/lib/libXau.so.6
Reading symbols from /usr/lib/libfontenc.so.1...done.
Loaded symbols for /usr/lib/libfontenc.so.1
Reading symbols from /lib/libz.so.1...done.
Loaded symbols for /lib/libz.so.1
Reading symbols from /usr/lib/libXdmcp.so.6...done.
Loaded symbols for /usr/lib/libXdmcp.so.6
Reading symbols from /lib/libm.so.6...done.
Loaded symbols for /lib/libm.so.6
Reading symbols from /lib/librt.so.1...done.
Loaded symbols for /lib/librt.so.1
Reading symbols from /lib/libgcc_s.so.1...done.
Loaded symbols for /lib/libgcc_s.so.1
Reading symbols from /lib/libc.so.6...done.
Loaded symbols for /lib/libc.so.6
Reading symbols from /lib/ld-linux.so.2...done.
Loaded symbols for /lib/ld-linux.so.2
Reading symbols from /lib/libpthread.so.0...done.
[Thread debugging using libthread_db enabled]
[New Thread -1210947008 (LWP 4351)]
Loaded symbols for /lib/libpthread.so.0
Reading symbols from /usr/lib/xorg/modules/libpcidata.so...done.
Loaded symbols for /usr/lib/xorg/modules//libpcidata.so
Reading symbols from /usr/lib/xorg/modules/fonts/libfreetype.so...done.
Loaded symbols for /usr/lib/xorg/modules//fonts/libfreetype.so
Reading symbols from /usr/lib/xorg/modules/fonts/libtype1.so...done.
Loaded symbols for /usr/lib/xorg/modules//fonts/libtype1.so
Reading symbols from /usr/lib/xorg/modules/extensions/libdbe.so...done.
Loaded symbols for /usr/lib/xorg/modules//extensions/libdbe.so
Reading symbols from /usr/lib/xorg/modules/extensions/libglx.so...done.
Loaded symbols for /usr/lib/xorg/modules//extensions/libglx.so
Reading symbols from /usr/lib/xorg/modules/extensions/libextmod.so...done.
Loaded symbols for /usr/lib/xorg/modules//extensions/libextmod.so
Reading symbols from /usr/lib/xorg/modules/drivers/v4l_drv.so...done.
Loaded symbols for /usr/lib/xorg/modules//drivers/v4l_drv.so
Reading symbols from /usr/lib/xorg/modules/extensions/libdri.so...done.
Loaded symbols for /usr/lib/xorg/modules//extensions/libdri.so
Reading symbols from /usr/lib/libdrm.so.2...done.
Loaded symbols for /usr/lib/libdrm.so.2
Reading symbols from /usr/lib/xorg/modules/drivers/fglrx_drv.so...done.
Loaded symbols for /usr/lib/xorg/modules//drivers/fglrx_drv.so
Reading symbols from /usr/lib/libstdc++.so.5...done.
Loaded symbols for /usr/lib/libstdc++.so.5
Reading symbols from /usr/lib/xorg/modules/input/kbd_drv.so...done.
Loaded symbols for /usr/lib/xorg/modules//input/kbd_drv.so
Reading symbols from /usr/lib/xorg/modules/input/mouse_drv.so...done.
Loaded symbols for /usr/lib/xorg/modules//input/mouse_drv.so
Reading symbols from /usr/lib/xorg/modules/libvgahw.so...done.
Loaded symbols for /usr/lib/xorg/modules//libvgahw.so
Reading symbols from /usr/lib/xorg/modules/libint10.so...done.
Loaded symbols for /usr/lib/xorg/modules//libint10.so
Reading symbols from /usr/lib/xorg/modules/libvbe.so...done.
Loaded symbols for /usr/lib/xorg/modules//libvbe.so
Reading symbols from /usr/lib/xorg/modules/linux/libfglrxdrm.so...done.
Loaded symbols for /usr/lib/xorg/modules/linux//libfglrxdrm.so
Reading symbols from /usr/lib/xorg/modules/libddc.so...done.
Loaded symbols for /usr/lib/xorg/modules//libddc.so
Reading symbols from /usr/lib/xorg/modules/libfb.so...done.
Loaded symbols for /usr/lib/xorg/modules//libfb.so
Reading symbols from /usr/lib/xorg/modules/libramdac.so...done.
Loaded symbols for /usr/lib/xorg/modules//libramdac.so
Reading symbols from /usr/lib/xorg/modules/libxaa.so...done.
Loaded symbols for /usr/lib/xorg/modules//libxaa.so
Reading symbols from /usr/lib/xorg/modules/glesx.so...done.
Loaded symbols for /usr/lib/xorg/modules//glesx.so
Reading symbols from /usr/lib/xorg/modules/extensions/libGLcore.so...done.
Loaded symbols for /usr/lib/xorg/modules//extensions/libGLcore.so
Failed to read a valid object file image from memory.
0xb7fc6410 in ?? ()
(gdb) cont
Continuing.


*** when lockup, i stopped running of X using ctrl+C ***


Program received signal SIGINT, Interrupt.
0xb7fa9800 in firegl_PM4WaitForIdle ()
   from /usr/lib/xorg/modules/linux//libfglrxdrm.so

(gdb) bt

#0  0xb7fa9800 in firegl_PM4WaitForIdle ()
   from /usr/lib/xorg/modules/linux//libfglrxdrm.so
#1  0xb799ee11 in atiddxAccelCPWaitForIdle ()
   from /usr/lib/xorg/modules//drivers/fglrx_drv.so
#2  0xb7726452 in XAACopyAreaFallback () from
/usr/lib/xorg/modules//libxaa.so
#3  0xb77276a7 in XAACopyArea () from /usr/lib/xorg/modules//libxaa.so
#4  0x0808460a in ProcCopyArea ()
#5  0x0813d621 in XaceCatchDispatchProc ()
#6  0x0808643f in Dispatch ()
#7  0x0806e885 in main ()
(gdb) cont
Continuing.


*** the X looping in function firegl_PM4WaitForIdle ***


(gdb) next
Single stepping until exit from function firegl_PM4WaitForIdle,
which has no line number information.


***  loop! don't finish, break using ctrl+C ***


(gdb) backtrace
#0  0xb7fa9900 in firegl_PM4WaitForIdle ()
   from /usr/lib/xorg/modules/linux//libfglrxdrm.so
#1  0xb799ee11 in atiddxAccelCPWaitForIdle ()
   from /usr/lib/xorg/modules//drivers/fglrx_drv.so
#2  0xb7726452 in XAACopyAreaFallback () from
/usr/lib/xorg/modules//libxaa.so
#3  0xb77276a7 in XAACopyArea () from /usr/lib/xorg/modules//libxaa.so
#4  0x0808460a in ProcCopyArea ()
#5  0x0813d621 in XaceCatchDispatchProc ()
#6  0x0808643f in Dispatch ()
#7  0x0806e885 in main ()


(gdb) disas
Dump of assembler code for function firegl_PM4WaitForIdle:
0xb7fa9740 <firegl_PM4WaitForIdle+0>:   push   %ebp
0xb7fa9741 <firegl_PM4WaitForIdle+1>:   mov    %esp,%ebp
0xb7fa9743 <firegl_PM4WaitForIdle+3>:   push   %edi
0xb7fa9744 <firegl_PM4WaitForIdle+4>:   push   %esi
0xb7fa9745 <firegl_PM4WaitForIdle+5>:   push   %ebx
0xb7fa9746 <firegl_PM4WaitForIdle+6>:   sub    $0x1c,%esp
0xb7fa9749 <firegl_PM4WaitForIdle+9>:   mov    0x8(%ebp),%ecx
0xb7fa974c <firegl_PM4WaitForIdle+12>:  mov    0x8(%ebp),%eax
0xb7fa974f <firegl_PM4WaitForIdle+15>:  call   0xb7fa7720
<__i686.get_pc_thunk.bx>
0xb7fa9754 <firegl_PM4WaitForIdle+20>:  add    $0x16c8,%ebx
0xb7fa975a <firegl_PM4WaitForIdle+26>:  mov    0x20(%ecx),%edx
0xb7fa975d <firegl_PM4WaitForIdle+29>:  mov    %edx,0xfffffff0(%ebp)
0xb7fa9760 <firegl_PM4WaitForIdle+32>:  mov    0x10(%eax),%ecx
0xb7fa9763 <firegl_PM4WaitForIdle+35>:  mov    %ecx,0xffffffec(%ebp)
0xb7fa9766 <firegl_PM4WaitForIdle+38>:  mov    (%ecx),%eax
0xb7fa9768 <firegl_PM4WaitForIdle+40>:  test   %eax,%eax
0xb7fa976a <firegl_PM4WaitForIdle+42>:  jne    0xb7fa976d
<firegl_PM4WaitForIdle+45>
0xb7fa976c <firegl_PM4WaitForIdle+44>:  int3   
0xb7fa976d <firegl_PM4WaitForIdle+45>:  test   $0x10,%al
0xb7fa976f <firegl_PM4WaitForIdle+47>:  jne    0xb7fa9919
<firegl_PM4WaitForIdle+473>
0xb7fa9775 <firegl_PM4WaitForIdle+53>:  mov    0xffffffec(%ebp),%edi
0xb7fa9778 <firegl_PM4WaitForIdle+56>:  test   %eax,%eax
0xb7fa977a <firegl_PM4WaitForIdle+58>:  mov    0x10(%edi),%ecx
0xb7fa977d <firegl_PM4WaitForIdle+61>:  jne    0xb7fa9780
<firegl_PM4WaitForIdle+64>
0xb7fa977f <firegl_PM4WaitForIdle+63>:  int3   
0xb7fa9780 <firegl_PM4WaitForIdle+64>:  mov    0xffffffec(%ebp),%edi
0xb7fa9783 <firegl_PM4WaitForIdle+67>:  mov    0x4(%edi),%edx
0xb7fa9786 <firegl_PM4WaitForIdle+70>:  lea    0x4(%edx),%esi
0xb7fa9789 <firegl_PM4WaitForIdle+73>:  cmp    0x8(%edi),%esi
0xb7fa978c <firegl_PM4WaitForIdle+76>:  ja     0xb7fa979a
<firegl_PM4WaitForIdle+90>
0xb7fa978e <firegl_PM4WaitForIdle+78>:  lea    0x6(%ecx),%esi
0xb7fa9791 <firegl_PM4WaitForIdle+81>:  cmp    %esi,0x14(%edi)
0xb7fa9794 <firegl_PM4WaitForIdle+84>:  jae    0xb7fa990b
<firegl_PM4WaitForIdle+459>
0xb7fa979a <firegl_PM4WaitForIdle+90>:  mov    0x8(%ebp),%edx
0xb7fa979d <firegl_PM4WaitForIdle+93>:  mov    $0x4,%ecx
0xb7fa97a2 <firegl_PM4WaitForIdle+98>:  mov    %ecx,0x4(%esp)
0xb7fa97a6 <firegl_PM4WaitForIdle+102>: mov    %edx,(%esp)
0xb7fa97a9 <firegl_PM4WaitForIdle+105>: call   0xb7fa75c0
<firegl_PM4Alloc@plt>
0xb7fa97ae <firegl_PM4WaitForIdle+110>: movl   $0x5c5,(%eax)
0xb7fa97b4 <firegl_PM4WaitForIdle+116>: add    $0x4,%eax
0xb7fa97b7 <firegl_PM4WaitForIdle+119>: movl   $0xf,(%eax)
0xb7fa97bd <firegl_PM4WaitForIdle+125>: add    $0x4,%eax
0xb7fa97c0 <firegl_PM4WaitForIdle+128>: movl   $0x5c8,(%eax)
0xb7fa97c6 <firegl_PM4WaitForIdle+134>: add    $0x4,%eax
0xb7fa97c9 <firegl_PM4WaitForIdle+137>: movl   $0x70000,(%eax)
0xb7fa97cf <firegl_PM4WaitForIdle+143>: mov    0x8(%ebp),%edi
0xb7fa97d2 <firegl_PM4WaitForIdle+146>: add    $0x4,%eax
0xb7fa97d5 <firegl_PM4WaitForIdle+149>: mov    %eax,0x4(%esp)
0xb7fa97d9 <firegl_PM4WaitForIdle+153>: mov    %edi,(%esp)
0xb7fa97dc <firegl_PM4WaitForIdle+156>: call   0xb7fa9ab0
<__fglDRMPM4Submit>
0xb7fa97e1 <firegl_PM4WaitForIdle+161>: mov    0xffffffec(%ebp),%edi
0xb7fa97e4 <firegl_PM4WaitForIdle+164>: mov    0x8(%ebp),%edx
0xb7fa97e7 <firegl_PM4WaitForIdle+167>: mov    0x4(%edi),%esi
0xb7fa97ea <firegl_PM4WaitForIdle+170>: mov    0x8(%edx),%ecx
0xb7fa97ed <firegl_PM4WaitForIdle+173>: mov    (%edi),%edx
0xb7fa97ef <firegl_PM4WaitForIdle+175>: and    $0x4,%edx
0xb7fa97f2 <firegl_PM4WaitForIdle+178>: lea    0x0(%esi),%esi
0xb7fa97f9 <firegl_PM4WaitForIdle+185>: lea    0x0(%edi),%edi
0xb7fa9800 <firegl_PM4WaitForIdle+192>: test   %edx,%edx
0xb7fa9802 <firegl_PM4WaitForIdle+194>: je     0xb7fa9900
<firegl_PM4WaitForIdle+448>
0xb7fa9808 <firegl_PM4WaitForIdle+200>: mov    0x710(%ecx),%eax
0xb7fa980e <firegl_PM4WaitForIdle+206>: cmp    %eax,%esi
0xb7fa9810 <firegl_PM4WaitForIdle+208>: jne    0xb7fa9800
<firegl_PM4WaitForIdle+192>
0xb7fa9812 <firegl_PM4WaitForIdle+210>: lea    0x0(%esi),%esi
0xb7fa9819 <firegl_PM4WaitForIdle+217>: lea    0x0(%edi),%edi
0xb7fa9820 <firegl_PM4WaitForIdle+224>: mov    0xe40(%ecx),%esi
0xb7fa9826 <firegl_PM4WaitForIdle+230>: test   %esi,%esi
0xb7fa9828 <firegl_PM4WaitForIdle+232>: js     0xb7fa9820
<firegl_PM4WaitForIdle+224>
0xb7fa982a <firegl_PM4WaitForIdle+234>: mov    0xffffffec(%ebp),%edi
0xb7fa982d <firegl_PM4WaitForIdle+237>: mov    0x38(%edi),%edx
0xb7fa9830 <firegl_PM4WaitForIdle+240>: test   %edx,%edx
0xb7fa9832 <firegl_PM4WaitForIdle+242>: jne    0xb7fa984d
<firegl_PM4WaitForIdle+269>
0xb7fa9834 <firegl_PM4WaitForIdle+244>: mov    0x130(%ecx),%esi
0xb7fa983a <firegl_PM4WaitForIdle+250>: mov    0xffffffec(%ebp),%ecx
0xb7fa983d <firegl_PM4WaitForIdle+253>: mov    %esi,0x3c(%ecx)
0xb7fa9840 <firegl_PM4WaitForIdle+256>: movl   $0x1,0x38(%ecx)
0xb7fa9847 <firegl_PM4WaitForIdle+263>: mov    0x8(%ebp),%eax
0xb7fa984a <firegl_PM4WaitForIdle+266>: mov    0x8(%eax),%ecx
0xb7fa984d <firegl_PM4WaitForIdle+269>: mov    0xffffffec(%ebp),%edx
0xb7fa9850 <firegl_PM4WaitForIdle+272>: mov    0x3c(%edx),%esi
0xb7fa9853 <firegl_PM4WaitForIdle+275>: mov    %esi,0x130(%ecx)
0xb7fa9859 <firegl_PM4WaitForIdle+281>: mov    0x8(%edx),%edi
0xb7fa985c <firegl_PM4WaitForIdle+284>: testb  $0x10,(%edx)
0xb7fa985f <firegl_PM4WaitForIdle+287>: mov    %edi,0x14(%edx)
0xb7fa9862 <firegl_PM4WaitForIdle+290>: jne    0xb7fa98e8
<firegl_PM4WaitForIdle+424>
0xb7fa9868 <firegl_PM4WaitForIdle+296>: mov    0x8(%ebp),%ecx
0xb7fa986b <firegl_PM4WaitForIdle+299>: mov    0x10(%ecx),%edx
0xb7fa986e <firegl_PM4WaitForIdle+302>: mov    (%edx),%eax
0xb7fa9870 <firegl_PM4WaitForIdle+304>: mov    0x10(%edx),%esi
0xb7fa9873 <firegl_PM4WaitForIdle+307>: test   %eax,%eax
0xb7fa9875 <firegl_PM4WaitForIdle+309>: jne    0xb7fa9878
<firegl_PM4WaitForIdle+312>
0xb7fa9877 <firegl_PM4WaitForIdle+311>: int3   
0xb7fa9878 <firegl_PM4WaitForIdle+312>: mov    0x4(%edx),%ecx
0xb7fa987b <firegl_PM4WaitForIdle+315>: lea    0x6(%ecx),%edi
0xb7fa987e <firegl_PM4WaitForIdle+318>: cmp    0x8(%edx),%edi
0xb7fa9881 <firegl_PM4WaitForIdle+321>: ja     0xb7fa988b
<firegl_PM4WaitForIdle+331>
0xb7fa9883 <firegl_PM4WaitForIdle+323>: lea    0x8(%esi),%edi
0xb7fa9886 <firegl_PM4WaitForIdle+326>: cmp    %edi,0x14(%edx)
0xb7fa9889 <firegl_PM4WaitForIdle+329>: jae    0xb7fa98f2
<firegl_PM4WaitForIdle+434>
0xb7fa988b <firegl_PM4WaitForIdle+331>: mov    0x8(%ebp),%esi
0xb7fa988e <firegl_PM4WaitForIdle+334>: mov    $0x6,%edx
0xb7fa9893 <firegl_PM4WaitForIdle+339>: mov    %edx,0x4(%esp)
0xb7fa9897 <firegl_PM4WaitForIdle+343>: mov    %esi,(%esp)
0xb7fa989a <firegl_PM4WaitForIdle+346>: call   0xb7fa75c0
<firegl_PM4Alloc@plt>
0xb7fa989f <firegl_PM4WaitForIdle+351>: movl   $0x5c5,(%eax)
0xb7fa98a5 <firegl_PM4WaitForIdle+357>: movl   $0xf,0x4(%eax)
0xb7fa98ac <firegl_PM4WaitForIdle+364>: movl   $0x57d,0x8(%eax)
0xb7fa98b3 <firegl_PM4WaitForIdle+371>: movl   $0x0,0xc(%eax)
0xb7fa98ba <firegl_PM4WaitForIdle+378>: movl   $0x5c8,0x10(%eax)
0xb7fa98c1 <firegl_PM4WaitForIdle+385>: movl   $0x40000,0x14(%eax)
0xb7fa98c8 <firegl_PM4WaitForIdle+392>: mov    0x8(%ebp),%edi
0xb7fa98cb <firegl_PM4WaitForIdle+395>: add    $0x18,%eax
0xb7fa98ce <firegl_PM4WaitForIdle+398>: mov    0x10(%edi),%ecx
0xb7fa98d1 <firegl_PM4WaitForIdle+401>: je     0xb7fa98e8
<firegl_PM4WaitForIdle+424>
0xb7fa98d3 <firegl_PM4WaitForIdle+403>: mov    0x18(%edi),%esi
0xb7fa98d6 <firegl_PM4WaitForIdle+406>: mov    0x4(%ecx),%edx
0xb7fa98d9 <firegl_PM4WaitForIdle+409>: sub    %esi,%eax
0xb7fa98db <firegl_PM4WaitForIdle+411>: sar    $0x2,%eax
0xb7fa98de <firegl_PM4WaitForIdle+414>: mov    %eax,%edi
0xb7fa98e0 <firegl_PM4WaitForIdle+416>: sub    %edx,%edi
0xb7fa98e2 <firegl_PM4WaitForIdle+418>: sub    %edi,0x14(%ecx)
0xb7fa98e5 <firegl_PM4WaitForIdle+421>: mov    %eax,0x4(%ecx)
0xb7fa98e8 <firegl_PM4WaitForIdle+424>: add    $0x1c,%esp
0xb7fa98eb <firegl_PM4WaitForIdle+427>: xor    %eax,%eax
0xb7fa98ed <firegl_PM4WaitForIdle+429>: pop    %ebx
0xb7fa98ee <firegl_PM4WaitForIdle+430>: pop    %esi
0xb7fa98ef <firegl_PM4WaitForIdle+431>: pop    %edi
0xb7fa98f0 <firegl_PM4WaitForIdle+432>: pop    %ebp
0xb7fa98f1 <firegl_PM4WaitForIdle+433>: ret    
0xb7fa98f2 <firegl_PM4WaitForIdle+434>: mov    0x8(%ebp),%eax
0xb7fa98f5 <firegl_PM4WaitForIdle+437>: mov    0x18(%eax),%edi
0xb7fa98f8 <firegl_PM4WaitForIdle+440>: lea    (%edi,%ecx,4),%eax
0xb7fa98fb <firegl_PM4WaitForIdle+443>: jmp    0xb7fa989f
<firegl_PM4WaitForIdle+351>
0xb7fa98fd <firegl_PM4WaitForIdle+445>: lea    0x0(%esi),%esi
0xb7fa9900 <firegl_PM4WaitForIdle+448>: mov    0xfffffff0(%ebp),%edi
0xb7fa9903 <firegl_PM4WaitForIdle+451>: mov    0x10(%edi),%eax
0xb7fa9906 <firegl_PM4WaitForIdle+454>: jmp    0xb7fa980e
<firegl_PM4WaitForIdle+206>
0xb7fa990b <firegl_PM4WaitForIdle+459>: mov    0x8(%ebp),%eax
0xb7fa990e <firegl_PM4WaitForIdle+462>: mov    0x18(%eax),%edi
0xb7fa9911 <firegl_PM4WaitForIdle+465>: lea    (%edi,%edx,4),%eax
0xb7fa9914 <firegl_PM4WaitForIdle+468>: jmp    0xb7fa97ae
<firegl_PM4WaitForIdle+110>
0xb7fa9919 <firegl_PM4WaitForIdle+473>: mov    0xffffffec(%ebp),%esi
0xb7fa991c <firegl_PM4WaitForIdle+476>: test   %eax,%eax
0xb7fa991e <firegl_PM4WaitForIdle+478>: mov    0x10(%esi),%ecx
0xb7fa9921 <firegl_PM4WaitForIdle+481>: jne    0xb7fa9924
<firegl_PM4WaitForIdle+484>
0xb7fa9923 <firegl_PM4WaitForIdle+483>: int3   
0xb7fa9924 <firegl_PM4WaitForIdle+484>: mov    0xffffffec(%ebp),%esi
0xb7fa9927 <firegl_PM4WaitForIdle+487>: mov    0x4(%esi),%edx
0xb7fa992a <firegl_PM4WaitForIdle+490>: mov    0xffffffec(%ebp),%esi
0xb7fa992d <firegl_PM4WaitForIdle+493>: lea    0x2(%edx),%edi
0xb7fa9930 <firegl_PM4WaitForIdle+496>: cmp    0x8(%esi),%edi
0xb7fa9933 <firegl_PM4WaitForIdle+499>: ja     0xb7fa993d
<firegl_PM4WaitForIdle+509>
0xb7fa9935 <firegl_PM4WaitForIdle+501>: lea    0x4(%ecx),%edi
0xb7fa9938 <firegl_PM4WaitForIdle+504>: cmp    %edi,0x14(%esi)
0xb7fa993b <firegl_PM4WaitForIdle+507>: jae    0xb7fa9956
<firegl_PM4WaitForIdle+534>
0xb7fa993d <firegl_PM4WaitForIdle+509>: mov    0x8(%ebp),%edx
0xb7fa9940 <firegl_PM4WaitForIdle+512>: mov    $0x2,%ecx
0xb7fa9945 <firegl_PM4WaitForIdle+517>: mov    %ecx,0x4(%esp)
0xb7fa9949 <firegl_PM4WaitForIdle+521>: mov    %edx,(%esp)
0xb7fa994c <firegl_PM4WaitForIdle+524>: call   0xb7fa75c0
<firegl_PM4Alloc@plt>
0xb7fa9951 <firegl_PM4WaitForIdle+529>: jmp    0xb7fa97c0
<firegl_PM4WaitForIdle+128>
0xb7fa9956 <firegl_PM4WaitForIdle+534>: mov    0x8(%ebp),%eax
0xb7fa9959 <firegl_PM4WaitForIdle+537>: mov    0x18(%eax),%esi
0xb7fa995c <firegl_PM4WaitForIdle+540>: lea    (%esi,%edx,4),%eax
0xb7fa995f <firegl_PM4WaitForIdle+543>: jmp    0xb7fa97c0
<firegl_PM4WaitForIdle+128>
0xb7fa9964 <firegl_PM4WaitForIdle+548>: lea    0x0(%esi),%esi
0xb7fa996a <firegl_PM4WaitForIdle+554>: lea    0x0(%edi),%edi
End of assembler dump.
