Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXLWPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXLWPeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXLWPeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 10:34:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXLWPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 10:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iyWso7E2Zd91rHU5FEqHyqRTTmNbo37IUbqKKuNkAB7DYrE6itIOhqEQXXCuhcvU5LHKhmhmNEXDFzdVukwTO72fTRahp+HrqNrsdem9pmErqHVvOvpRTNqXYzL2Mg7Fl78tU1suwfIykcdE8wev/S65By+KQ2MLJnw3eBllFbY=
Message-ID: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com>
Date: Sun, 23 Dec 2007 17:33:58 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>
Subject: [MIPS] MEM_SDREFCFG is not defined for Alchemy DB1550 (compile fail)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I have:
CONFIG_MIPS_DB1550
CONFIG_SOC_AU1550
CONFIG_SOC_AU1X00
CONFIG_PM

MEM_SDREFCFG is used at:
arch/mips/au1000/common/power.c::pm_do_freq()

While the MEM_SDREFCFG constant is declare only for CONFIG_SOC_AU1000,
CONFIG_SOC_AU1500, CONFIG_SOC_AU1100 at:
include/asm-mips/mach-au1x00/au1000.h

Maybe MEM_SDREFCFG should be defined for CONFIG_SOC_AU1X00?
Or there should be #ifdef for its usage in power.c?

Best Regards,
Alon Bar-Lev.
