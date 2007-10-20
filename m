Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbXJTHbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbXJTHbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 03:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXJTHav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 03:30:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:49933 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXJTHau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 03:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=A/KjIVf/CrIJDxqCYyQ1NMqxkFLcDOkReeEtuI4EVM7K+RKFGwIiB7R4TJNtleMnJehVVAo0yp8A1IMFAZRUe01PJg33MDLyFho7x5RApz0q5GNhyGr1ssptFnYpcaGKrbb9xZ/yhPx1ZGDX3ws6H0f8vwja6haZZ0fKswXIpZQ=
Message-ID: <86802c440710200030y4bdff609m35966a6300f697b2@mail.gmail.com>
Date: Sat, 20 Oct 2007 00:30:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: kbuild: kconfig source with " " or not
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

in Kconfig, most of source to include other kconfig has "..."

for example:

in arch/x86_64/Kconfig:
source "net/Kconfig"

but some other don't

< ./drivers/w1/Kconfig:source drivers/w1/masters/Kconfig
< ./drivers/w1/Kconfig:source drivers/w1/slaves/Kconfig
< ./drivers/i2c/Kconfig:source drivers/i2c/algos/Kconfig
< ./drivers/i2c/Kconfig:source drivers/i2c/busses/Kconfig
< ./drivers/i2c/Kconfig:source drivers/i2c/chips/Kconfig
< ./arch/frv/Kconfig:source kernel/power/Kconfig
< ./arch/v850/Kconfig:source init/Kconfig
< ./arch/v850/Kconfig:source drivers/mtd/Kconfig
< ./arch/v850/Kconfig:source drivers/parport/Kconfig
< ./arch/v850/Kconfig:#source drivers/pnp/Kconfig
< ./arch/v850/Kconfig:source drivers/block/Kconfig
< ./arch/v850/Kconfig:#source drivers/misc/Config.in
< ./arch/ia64/Kconfig:source kernel/Kconfig.hz
< ./arch/i386/Kconfig:source kernel/Kconfig.hz
< ./arch/i386/Kconfig:source kernel/power/Kconfig
< ./arch/ppc/Kconfig:source arch/ppc/platforms/4xx/Kconfig
< ./arch/ppc/Kconfig:source arch/ppc/platforms/85xx/Kconfig
< ./arch/ppc/Kconfig:source kernel/Kconfig.hz
< ./arch/ppc/Kconfig:source kernel/Kconfig.preempt
< ./arch/ppc/Kconfig:source kernel/power/Kconfig
< ./arch/x86_64/Kconfig:source kernel/Kconfig.hz
< ./arch/x86_64/Kconfig:source kernel/power/Kconfig
< ./arch/x86_64/Kconfig:source drivers/Kconfig
< ./arch/x86_64/Kconfig:source fs/Kconfig
< ./arch/s390/Kconfig:source kernel/Kconfig.hz
< ./arch/cris/Kconfig:source mm/Kconfig
< ./arch/cris/Kconfig:source arch/cris/arch-v10/Kconfig
< ./arch/cris/Kconfig:source arch/cris/arch-v10/drivers/Kconfig
< ./arch/cris/Kconfig:#source drivers/misc/Config.in
< ./arch/powerpc/Kconfig:source kernel/time/Kconfig
< ./arch/powerpc/Kconfig:source kernel/Kconfig.hz
< ./arch/powerpc/Kconfig:source kernel/Kconfig.preempt
< ./arch/powerpc/Kconfig:source kernel/power/Kconfig
< ./arch/sh64/Kconfig:source init/Kconfig
< ./arch/sh/Kconfig:source kernel/Kconfig.hz
< ./arch/sh/Kconfig:source kernel/power/Kconfig
< ./arch/sparc64/Kconfig:source kernel/Kconfig.hz
< ./arch/arm/Kconfig:source arch/arm/mm/Kconfig
< ./arch/blackfin/Kconfig:source kernel/Kconfig.hz
< ./block/Kconfig:source block/Kconfig.iosched
< ./security/Kconfig:source security/selinux/Kconfig

better to keep them consistent

YH
