Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYAXPQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYAXPQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYAXPQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:16:35 -0500
Received: from mail0.scram.de ([78.47.204.202]:47491 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYAXPQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:16:34 -0500
X-Spam-Score: -4.231
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4798AB95.8040405@scram.de>
Date: Thu, 24 Jan 2008 16:15:33 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv3 0/7] [POWERPC] 8xx cleanups
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series against paulus for-2.6.25 tree to clean up various 8xx related stuff.
The series can be pulled from git://git.bocc.de/dbox2.git cleanup.
Old patches 2+4 have been merged into Patch 2. Patch 4 has been modified to move the
prototypes into a new platforms/8xx/mpc8xx.h. Patch 5 leaves the PCMCIA bits in
asm-powerpc/mpc8xx.h as this driver needs to be fixed first (unfortunately, i don't
have an 8xx board with PCMCIA). I would suggest removing asm-powerpc/mpc8xx.h after
ARCH=ppc is gone to avoid adding #ifdefs to all shared drivers.

I also modified an option in Thunderbird so i hope whitespaces are OK now :-/

[POWERPC] Remove unused m8xx_cpm_hostalloc/free/dump()
[POWERPC] Rename m8xx_pic_init to mpc8xx_pics_init
[POWERPC] Remove unneeded and misspelled prototype m8xx_calibrate_decr
[POWERPC] Remove sysdev/commproc.h
[POWERPC] Get rid of conditional includes of board specific setup
[POWERPC] Rename commproc to cpm1 and cpm2_common.c to cpm2.c
[POWERPC] Move definition of buffer descriptor to cpm.h

Thanks,
Jochen
