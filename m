Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbZJ2EVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbZJ2EVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 00:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZJ2EVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 00:21:41 -0400
Received: from gherkin.frus.com ([192.158.254.49]:41375 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZJ2EVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 00:21:41 -0400
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2009 00:21:40 EDT
Date: Wed, 28 Oct 2009 22:53:05 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: debian-alpha@lists.debian.org
Subject: [BUG] 2.6.32-rc5 build failure on Alpha
Message-ID: <20091029035304.GA23537@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainline 2.6.32-rc5 kernel build failure.  The last few lines of the kernel
build output are:

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: "saved_config" [vmlinux] is COMMON symbol
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/alpha/kernel/vmlinux.lds:241: undefined symbol `THREAD_SIZE' referenced in expression
make: *** [.tmp_vmlinux1] Error 1

-- 
------------------------------------------------------------------------
Bob Tracy          |  "Every normal man must be tempted at times to spit
rct@frus.com       |   upon his hands, hoist the black flag, and begin
                   |   slitting throats."	-- H.L. Mencken
------------------------------------------------------------------------
