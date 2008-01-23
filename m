Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYAWP7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYAWP7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYAWP7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:59:06 -0500
Received: from mail0.scram.de ([78.47.204.202]:36692 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYAWP7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:59:04 -0500
X-Spam-Score: -4.181
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4797641F.4000902@scram.de>
Date: Wed, 23 Jan 2008 16:58:23 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 0/8] [POWERPC] 8xx cleanups
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series against paulus for-2.6.25 tree to clean up various 8xx related stuff.
The series can be pulled from git://git.bocc.de/dbox2.git cleanup.
Patch 6 has been modified to remove the #ifdefs as suggested by Arndt Bergmann.
Patch 8 is a new one.

[POWERPC] Remove unused m8xx_cpm_hostalloc/free/dump()
[POWERPC] Rename m8xx_pic_init to mpc8xx_pics_init
[POWERPC] Remove unneeded and misspelled prototype m8xx_calibrate_decr
[POWERPC] Remove declaration of m8xx_pic_init.
[POWERPC] Remove sysdev/commproc.h
[POWERPC] Get rid of conditional includes of board specific setup
[POWERPC] Rename commproc to cpm1 and cpm2_common.c to cpm2.c
[POWERPC] Move definition of buffer descriptor to cpm.h

Thanks,
Jochen
