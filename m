Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbXEIXGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbXEIXGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbXEIXF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:05:56 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41569
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbXEIXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:05:55 -0400
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org
Subject: Building ppc/powerpc kernel to run under QEMU.
Date: Wed, 9 May 2007 18:39:55 -0400
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091839.55149.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Who do I ask about the status of the migration from ARCH=ppc to ARCH=powerpc?

I've been putting around with my Firmware Linux project trying to add powerpc 
as a supported platform.  I can build kernels that qemu can boot (such as 
a "prep" kernel) using ARCH=ppc, but that one doesn't support make 
headers_install.

Using ARCH=powerpc makes headers_install work, but there's no kernel .config 
I've been able to come up with that generates a kernel I can boot under qemu.

I could add a special case to my build script, but so far I've got it building 
eight targets (x86, x86-64, mips, mipsel, armv4l, armv5l, and sparc) with the 
same ARCH= for headers_install and the actual kernel compile.  It seems there 
_should_ be a way to do this for as prominent an architecture as PowerPC.

Who should I ask about this?

Rob
