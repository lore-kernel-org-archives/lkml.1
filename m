Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZEBNuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZEBNuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 09:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZEBNuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 09:50:06 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:47030 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZEBNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 09:50:05 -0400
Message-ID: <49FC4F88.3090403@web.de>
Date: Sat, 02 May 2009 15:50:00 +0200
From: Lee <lee-in-berlin@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090409 Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.30-rc4: compile fail with CONFIG_DRM_I915=y
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/SrlXipWL77SXFD55qoJzR3HyqxabQNNhKJbu3
	DV43NEO6MDDWl04SG/LaZ76FDLviHIPkbxV5LLjpF3iHvO+PPP
	FN3DYCkEGGT13qbL8nGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

compiling 2.6.30-rc4 with following options will result in an compile error:

CONFIG_DRM_I915=y
CONFIG_ACPI_VIDEO=m


drivers/video/backlight/backlight.c: In function ‘backlight_device_register’:
drivers/video/backlight/backlight.c:247: warning: format not a string literal 
and no format arguments
drivers/video/output.c: In function ‘video_output_register’:
drivers/video/output.c:99: warning: format not a string literal and no format 
arguments
drivers/usb/storage/libusual.c: In function ‘usu_probe_thread’:
drivers/usb/storage/libusual.c:159: warning: format not a string literal and 
no format arguments
drivers/built-in.o: In function `intel_opregion_free':
(.text+0xaf051): undefined reference to `acpi_video_exit'
drivers/built-in.o: In function `intel_opregion_init':
(.text+0xaf411): undefined reference to `acpi_video_register'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/home/randall/kernel-source'
make: *** [debian/stamp/build/kernel] Error 2

Compiling the kernel with both options as module or both options built-in 
results in a working kernel.

Kind regards,
Lee
