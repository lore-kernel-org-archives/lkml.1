Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbZDXVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbZDXVU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZDXVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:20:17 -0400
Received: from nn7.de ([85.214.94.156]:36247 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbZDXVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:20:16 -0400
Subject: 2.6.30-rc3 still fails to build
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Apr 2009 23:20:12 +0200
Message-Id: <1240608012.5488.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

still the same thing...

  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `intel_opregion_init':
(.text+0xcf239): undefined reference to `acpi_video_register'
make: *** [.tmp_vmlinux1] Error 1


-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
