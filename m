Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYAWQOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYAWQOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYAWQOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:14:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:47768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYAWQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:14:10 -0500
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Message-Id: <CA8FFE19-B84A-426B-9B1C-EF0F7C87AE47@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <4797641F.4000902@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCHv2 0/8] [POWERPC] 8xx cleanups
Date: Wed, 23 Jan 2008 10:11:01 -0600
References: <4797641F.4000902@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23, 2008, at 9:58 AM, Jochen Friedrich wrote:

> Hi,
>
> this is a series against paulus for-2.6.25 tree to clean up various  
> 8xx related stuff.
> The series can be pulled from git://git.bocc.de/dbox2.git cleanup.
> Patch 6 has been modified to remove the #ifdefs as suggested by  
> Arndt Bergmann.
> Patch 8 is a new one.
>
> [POWERPC] Remove unused m8xx_cpm_hostalloc/free/dump()
> [POWERPC] Rename m8xx_pic_init to mpc8xx_pics_init
> [POWERPC] Remove unneeded and misspelled prototype m8xx_calibrate_decr
> [POWERPC] Remove declaration of m8xx_pic_init.
> [POWERPC] Remove sysdev/commproc.h
> [POWERPC] Get rid of conditional includes of board specific setup
> [POWERPC] Rename commproc to cpm1 and cpm2_common.c to cpm2.c
> [POWERPC] Move definition of buffer descriptor to cpm.h

These roughly look good, had a few comments.  Don't see any reason why  
they can't go in.

What impact do the have on boards in arch/ppc being able to build?

- k
