Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYCQSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYCQSGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYCQSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:06:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:29331 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbYCQSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R1Dzy9ShWafZpGDSTyZAVla7EG+QCsZMTkji4jYPrNJtJT0Ouhh5R0HmUIAlJx1IhLzwGrrt6Ryw/zLnY2G0Z9y1j2wFgJO5aiKzc9TFAAZT+z0QoF5EDcqccaAMsXlQXgkMfEB3d98p91k6dxidgvWomVL2IvcRpYW3DxKUDk4=
Message-ID: <dd18b0c30803171106m55670b2fg557b23e4e2285ba1@mail.gmail.com>
Date: Mon, 17 Mar 2008 18:06:02 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: capability.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I seem to be very confused on how to install fglrx on 2.6.25-*
below is the warnings and errors,


cleaning...
patching 'highmem.h'...
assuming new VMA API since we do have kernel 2.6.x...
def_vma_api_version=-DFGL_LINUX253P1_VMA_API
 Assuming default VMAP API
 Assuming default munmap API
doing Makefile based build for kernel 2.6.x and higher
make -C /lib/modules/2.6.25-rc6/build
SUBDIRS=/lib/modules/fglrx/build_mod/2.6.x modules
make[1]: Entering directory `/home/kernel/linux-2.6.25-rc6'
  CC [M]  /lib/modules/fglrx/build_mod/2.6.x/firegl_public.o
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
'KCL_SetPageNoCache':
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1161: warning:
'change_page_attr' is deprecated (declared at
include/asm/cacheflush.h:28)
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
'KCL_PosixSecurityCapGetEffectiveVector':
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1888: error:
implicit declaration of function 'cap_t'
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
'KCL_PosixSecurityCapSetEffectiveVector':
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1896: error:
invalid lvalue in assignment
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
'__ke_check_pci':
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1951: warning:
'pci_find_slot' is deprecated (declared at include/linux/pci.h:508)
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
'__ke_pci_find_slot':
/lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:2840: warning:
'pci_find_slot' is deprecated (declared at include/linux/pci.h:508)
make[2]: *** [/lib/modules/fglrx/build_mod/2.6.x/firegl_public.o] Error 1
make[1]: *** [_module_/lib/modules/fglrx/build_mod/2.6.x] Error 2
make[1]: Leaving directory `/home/kernel/linux-2.6.25-rc6'
make: *** [kmod_build] Error 2
build failed with return value 2


Under firegl_public.c it seems the module is requesting a cap_t  get
and receive an effective vector.
With the new capability.h file, what is the capability that replaces cap_t?


-- 
Justin P. Mattock
