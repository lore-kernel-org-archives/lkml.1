Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbXK2OU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbXK2OU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761421AbXK2OUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:20:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:27885 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbXK2OUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:20:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=v78rKX9tRoV5tTB/NcMpnIFEqTbzitSRNiQ/cuJhHoSA4LkC//JCHm5nKvPmP6KEVhDjJhW5zTfy27M4DkIM6IRX7dUP/wUdTTD+WmwGJvV28JvrIb6QB2Go9rB/RkO6sfR8mT0100WIK42gxN7pUIw6VgQbWfBVR3eD6neaQFc=
From: Chris Clayton <chris2553@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc3-git4 build warnings
Date: Thu, 29 Nov 2007 14:19:49 +0000
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711291419.49261.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just built 2.6.24-rc3-git4 and got the following two warnings.

  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x90b6): Section mismatch: reference to
.init.text:cache_remove_shared_cpu_map (between 'free_cache_attributes' and
'show_level')
WARNING: vmlinux.o(.init.text+0x143bd): Section mismatch: reference to
.exit.text:cpufreq_stats_free_table (between 'cpufreq_stat_cpu_callback' and
'cpufreq_stats_init')
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map

[...]

  OBJCOPY arch/x86/boot/setup.bin
  AS      arch/x86/boot/compressed/head_32.o
  CC      arch/x86/boot/compressed/misc_32.o
include/asm/processor_32.h: In function `native_get_debugreg':
include/asm/processor_32.h:530: warning: asm operand 0 probably doesn't
match constraints
include/asm/processor_32.h: In function `native_set_debugreg':
include/asm/processor_32.h:557: warning: asm operand 0 probably doesn't
match constraints
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz


Please cc me on any reply - I'm not subscribed.

Chris
-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
