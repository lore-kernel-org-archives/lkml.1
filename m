Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZDPK4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZDPK4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZDPK4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:56:21 -0400
Received: from smtpauth.net4india.com ([202.71.129.139]:57872 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923AbZDPK4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:56:20 -0400
Message-ID: <49E70EA3.1050804@xenontk.org>
Date: Thu, 16 Apr 2009 16:25:31 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: mjg59@srcf.ucam.org
CC: linux-kernel@vger.kernel.org, eric@anholt.net, len.brown@intel.com
Subject: 2.6.30-rc2 Build Broken
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Your commit 74a365b3f354fafc537efa5867deb7a9fadbfe27 breaks the latest
git if ACPI video is selected as a module and i915 is compiled in.

Here is the error:

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `intel_opregion_init':
/home/david/Builds/kernels/linux-2.6/drivers/gpu/drm/i915/i915_opregion.c:376:
undefined reference to `acpi_video_register'
make: *** [.tmp_vmlinux1] Error 1

Regards,
David.
