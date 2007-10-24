Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXJWRwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXJWRwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJWRwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:52:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:1197 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXJWRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=gLltwVTRocTwNo7z1TDcpBrDYQZuZHq1E9VZiOAJQ/0s/Y8D0zTUypkTfWnHb5k+JNRNsbTI/qGdqNbdxo5xCQeDG2r41nURIRSlc6RNOtSC1L2dqLE6bC+bGq+UfTwAowz0k3VXO19N5FyePjT2RHsmRLSsH+eayMoFiX0CCjQ=
Date: Tue, 23 Oct 2007 19:52:07 -0700
To: Russell King <linux@arm.linux.org.uk>
Cc: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [ARM] : Section mismatch : reference to......
Message-Id: <20071023195207.e52e22e5.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Best way to handle this?


  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x9afc): Section mismatch: reference to .init.text:sa1110_mb_enable (between 'sa1111_probe' and 'sa1111_remove')
WARNING: vmlinux.o(.text+0x13b1ac): Section mismatch: reference to .init.text:pcmcia_jornada720_init (between 'pcmcia_probe' and 'pcmcia_remove')
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  OBJCOPY arch/arm/boot/Image
  Kernel: arch/arm/boot/Image is ready
  AS      arch/arm/boot/compressed/head.o
  GZIP    arch/arm/boot/compressed/piggy.gz
  AS      arch/arm/boot/compressed/piggy.o
  CC      arch/arm/boot/compressed/misc.o
  AS      arch/arm/boot/compressed/head-sa1100.o
  LD      arch/arm/boot/compressed/vmlinux
  OBJCOPY arch/arm/boot/zImage
  Kernel: arch/arm/boot/zImage is ready
