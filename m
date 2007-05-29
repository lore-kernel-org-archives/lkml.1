Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXE2EqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXE2EqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 00:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbXE2EqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 00:46:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:53139 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXE2Ep7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 00:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mv0FcWfxng1fJ+SctqygGOyIQ9JBd6MpPhmUJp9/VRwATr/9Lrrl+wlB8wKlt11YxluDTQmnBL/pUmnpw6iipZflsOa+dwnBBffZ3XN3NFRElAQBrZ2fJvvQYIntXc3lKp3Yc6eB/SXr0u6x2IcKWuHW6RrK/trDPLKUStQ7v+U=
Message-ID: <2bd9ebfa0705282145t34ed211bs48c7b31fcd9420a5@mail.gmail.com>
Date: Tue, 29 May 2007 10:15:58 +0530
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: warning while building module.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi all

while building module i was getting following warning and it terminate
module building stage

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

i was trying to fix with online available patches but does not help out.
please cc to me

thanks
TEJ
