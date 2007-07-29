Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXG2PCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXG2PCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763681AbXG2O6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:05 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:53144 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764328AbXG2O6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:00 -0400
Date: Sun, 29 Jul 2007 10:57:33 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: nvidia installer DIW with 2.6.23-rc1
To: linux-kernel@vger.kernel.org
Message-id: <200707291057.34291.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I got around to building the 2.6.23-rc1 tree, updated to yesterday with git 
from the linus tree.  The build was fairly clean, but when I rebooted to it, 
the latest nvidia installer fails, with these messages:

nvidia-installer log file '/var/log/nvidia-installer.log'
creation time: Sun Jul 29 10:14:04 2007

option status:
  license pre-accepted    : false
  update                  : false
  force update            : false
  expert                  : false
  uninstall               : false
  driver info             : false
  precompiled interfaces  : true
  no ncurses color        : false
  query latest version    : false
  OpenGL header files     : true
  no questions            : false
  silent                  : false
  no recursion            : false
  no backup               : false
  kernel module only      : false
  sanity                  : false
  add this kernel         : false
  no runlevel check       : false
  no network              : false
  no ABI note             : false
  no RPMs                 : false
  no kernel module        : false
  force SELinux           : default
  no X server check       : false
  force tls               : (not specified)
  X install prefix        : (not specified)
  X library install path  : (not specified)
  X module install path   : (not specified)
  OpenGL install prefix   : (not specified)
  OpenGL install libdir   : (not specified)
  utility install prefix  : (not specified)
  utility install libdir  : (not specified)
  doc install prefix      : (not specified)
  kernel name             : (not specified)
  kernel include path     : (not specified)
  kernel source path      : (not specified)
  kernel output path      : (not specified)
  kernel install path     : (not specified)
  proc mount point        : /proc
  ui                      : (not specified)
  tmpdir                  : /tmp
  ftp mirror              : ftp://download.nvidia.com
  RPM file list           : (not specified)
[...]  
   NVIDIA: calling KBUILD...
   make CC=cc KBUILD_OUTPUT=/lib/modules/2.6.23-rc1/build 
KBUILD_VERBOSE=1 -C /
   lib/modules/2.6.23-rc1/source 
SUBDIRS=/tmp/selfgz9678/NVIDIA-Linux-x86-100.1
   4.11-pkg1/usr/src/nv modules
   make -C /lib/modules/2.6.23-rc1/build \
   	KBUILD_SRC=/usr/src/linux.git \   <-------has softlink to linux-2.6.23-rc1
   	KBUILD_EXTMOD="/tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv" 
   -f /usr/src/linux.git/Makefile modules
   test -e include/linux/autoconf.h -a -e include/config/auto.conf || (		\
   	echo;								\
   	echo "  ERROR: Kernel configuration is invalid.";		\
   	echo "         include/linux/autoconf.h or include/config/auto.conf are 
missing.";	\
   	echo "         Run 'make oldconfig && make prepare' on kernel src to fix 
it
------------
I've done the above, no effect
------------
[...]     
cc -Wp,-MD,/tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/.nv.
   
o.d  -nostdinc -isystem /usr/lib/gcc/i386-redhat-linux/4.1.2/include -D__KER
   NEL__ -Iinclude -Iinclude2 -I/usr/src/linux.git/include -include 
include/lin
   ux/autoconf.h  -I/tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv 
   -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-c
   
ommon -Werror-implicit-function-declaration -Os -pipe -msoft-float -mregparm
   
=3 -freg-struct-return -mpreferred-stack-boundary=2 -march=athlon -mtune=gen
   
eric -ffreestanding -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS
   _CFI_SIGNAL_FRAME=1 -
   
I/usr/src/linux.git/include/asm-i386/mach-default -Iinclude/asm-i386/mach-de
   
fault -fomit-frame-pointer -fno-stack-protector -Wdeclaration-after-statemen
   
t -Wno-pointer-sign  -I/tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/s
   
rc/nv -Wall -Wimplicit -Wreturn-type -Wswitch -Wformat -Wchar-subscripts -Wp
   
arentheses -Wpointer-arith -Wno-multichar -Werror -O -fno-common -msoft-floa
   
t -MD -Wsign-compare -Wno-cast-qual -Wno-error -D_LOOSE_KERNEL_NAMES -D__KER
   
NEL__ -DMODULE -DNVRM -DNV_VERSION_STRING=\"100.14.11\" -UDEBUG -U_DEBUG -DN
   
DEBUG -DNV_SIGNAL_STRUCT_RLIM -DNV_MULTIPLE_BRIDGE_AGPGART_PRESENT -DNV_PCI_
   
GET_CLASS_PRESENT -DNV_SYSCTL_MAX_MAP_COUNT_PRESENT -DNV_PM_MESSAGE_T_PRESEN
   
T -DNV_PCI_CHOOSE_STATE_PRESENT -DNV_VM_INSERT_PAGE_PRESENT -DNV_OLD_MM_KGDB
   
_BREAKPOINT_PRESENT -DNV_REMAP_PFN_RANGE_PRESENT -DNV_CHANGE_PAGE_ATTR_PRESE
   
NT -DNV_ACQUIRE_CONSOLE_SEM_PRESENT -DNV_VMAP_4_PRESENT -DMODULE -D"KBUILD_S
   
TR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(nv)"  -D"KBUILD_MODNAME=KBUILD_STR(n
   vidia)" -c -o /tmp/selfgz9678/NVIDIA
   -Linux-x86-100.14.11-pkg1/usr/src/nv/nv.o /tmp/selfgz9678/NVIDIA-Linux-x86-1
   00.14.11-pkg1/usr/src/nv/nv.c
   In file included from include/linux/list.h:9,
                    from include/linux/preempt.h:12,
                    from include/linux/spinlock.h:50,
                    from include/linux/seqlock.h:30,
                    from include/linux/time.h:9,
                    from include/linux/timex.h:58,
                    from include/linux/sched.h:54,
                    from include/linux/utsname.h:36,
                    
from /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/sr
   c/nv/nv-linux.h:20,
                    
from /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/sr
   c/nv/nv.c:15:
   include/linux/prefetch.h: In function ‘prefetch_range’:
   include/linux/prefetch.h:62: warning: pointer of type ‘void *’ used in a
   rithmetic
   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c: In 
function
   ‘nvidia_init_module’:
   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c:1326: 
error:
   too many arguments to function ‘kmem_cache_create’
   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c:1435: 
error:
   too many arguments to function ‘kmem_cache_create’
   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c:1569: 
error:
   void value not ignored as it ought to be
   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c: In 
function
   ‘nvidia_exit_module’:
   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c:1601: 
error:
   void value not ignored as it ought to be
   make[4]: *** 
[/tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.
   o] Error 1
   make[3]: *** 
[_module_/tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/sr
   c/nv] Error 2
   make[2]: *** [modules] Error 2
   NVIDIA: left KBUILD.
   nvidia.ko failed to build!
   make[1]: *** [module] Error 1
   make: *** [module] Error 2
------------

Is this a known problem?  Do I need to report it to nvidia somehow?  It looks 
to me like it may be their problem, and I have submitted it, but if anyone 
has a better idea, please advise.  System is FC6, uptodate as of yesterday.
 
Thanks all.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
This will be a memorable month -- no matter how hard you try to forget it.
