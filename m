Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbZLPJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbZLPJDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbZLPJDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:03:17 -0500
Received: from smtp.nokia.com ([192.100.122.230]:21865 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZLPJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:03:13 -0500
Date: Wed, 16 Dec 2009 11:02:24 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Balaji T K <balajitk@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next:  tree build failure
Message-ID: <20091216090224.GB19749@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091216182132.357359a6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091216182132.357359a6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Dec 2009 09:02:57.0708 (UTC) FILETIME=[8FA5BEC0:01CA7E2E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 16, 2009 at 08:21:32AM +0100, ext Stephen Rothwell wrote:
>Hi Liam,
>
>Today's linux-next build (powerpc allyesconfig) failed like this:
>
>drivers/regulator/twl-regulator.c: In function 'twlreg_disable':
>drivers/regulator/twl-regulator.c:158: error: 'P1_GRP' undeclared (first use in this function)
>drivers/regulator/twl-regulator.c:158: error: 'P2_GRP' undeclared (first use in this function)
>drivers/regulator/twl-regulator.c:158: error: 'P3_GRP' undeclared (first use in this function)
>drivers/regulator/twl-regulator.c: At top level:
>drivers/regulator/twl-regulator.c:358: error: 'twlldo_list_voltage' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:450:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:450: error: 'TWL_ADJUSTABLE_LDO' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:451:40: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:452:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:453:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:454:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:455:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:456:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:457:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:458:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:459:34: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:460:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:461:40: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
>drivers/regulator/twl-regulator.c:461: error: 'TWL_FIXED_LDO' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:462:39: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:463:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
>drivers/regulator/twl-regulator.c:464:34: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:465:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:466:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
>drivers/regulator/twl-regulator.c:467:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
>drivers/regulator/twl-regulator.c:468:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
>drivers/regulator/twl-regulator.c:469:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
>drivers/regulator/twl-regulator.c:474: error: 'VAUX1_6030_VSEL_table' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:474: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:474: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:475: error: 'VAUX2_6030_VSEL_table' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:475: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:475: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:476: error: 'VAUX3_6030_VSEL_table' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:476: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:476: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:477: error: 'VMMC_VSEL_table' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:477: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:477: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:478: error: 'VPP_VSEL_table' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:478: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:478: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:479: error: 'VUSIM_VSEL_table' undeclared here (not in a function)
>drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:479: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in declaration of 'type name'
>drivers/regulator/twl-regulator.c:479: error: negative width in bit-field '<anonymous>'
>drivers/regulator/twl-regulator.c: In function 'twlreg_probe':
>drivers/regulator/twl-regulator.c:544: error: implicit declaration of function 'twl4030reg_write'
>
>I guess we knew this was coming :-(
>
>Caused by a bad rebase of the voltage tree onto Linus' tree (in order to
>do fixups for commit fc7b92fca4e546184557f1c53f84ad57c66b7695 "mfd:
>Rename all twl4030_i2c*" and others).
>
>I have reverted all the commits in the voltage tree that touched
>drivers/regulator/twl-regulator.c for today:
>
>6051d7a2786c57d0c5c4227dd9ddfc348a86ce91 "twl4030-regulator: Fixes VAUX1-3 exclusion introduced"
>2677c78184a52edcc228c20a1c05c14925118293 "Reset REMAP configuration in regulator probe"
>de449258306274739ed3a747f49b9ac8f91f9e4a "Define critical regulators as always_on"
>66d65d352f6fd61dd5695925906b140f1e0ac9c3 "twl4030-regulator: Add all TWL regulators to twreg_info"
>f33a0d47bd44dbf44a45c33b32e1e3bbbf8d06e6 "twl4030-regulator: Remove regulator from all groups when disabling"
>
>Please fix up this tree properly.  You may have been better off merging
>Linus' tree into yours and fixing up the merge commit than trying to do
>the rebase.

All this crap would not have come if we weren't to rename twl4030 into 
twl. The argument that we need to rename files to make the code reusable 
is plain STUPID.

I made my point several times that we don't need to rename the files to 
make the code reusable, twl4030-*.c were already supporting twl4030, 
twl5030, twl5031 and some of the tps versions. Now several trees are 
broken because of the stupid mess created by one person who can't even 
run make when creating a patch. Now we have to pay the price and have a 
broken bisect point, great.

-- 
balbi
