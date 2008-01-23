Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYAWQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYAWQMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYAWQHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:07:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:59874 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbYAWQHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:07:11 -0500
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Message-Id: <83FEE161-D10D-4E21-BDB3-D0B6D49668CE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <479764B8.4010909@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCHv2 5/8] [POWERPC] Remove sysdev/commproc.h
Date: Wed, 23 Jan 2008 10:06:44 -0600
References: <479764B8.4010909@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23, 2008, at 10:00 AM, Jochen Friedrich wrote:

> Move cpm1 specific prototypes to asm/commproc.h and mpc8xx specific
> prototypes to asm/mpc8xx.h. Adjust includes accordingly. Remove now
> unneeded sysdev/commproc.h.
>
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
> arch/powerpc/platforms/8xx/ep88xc.c          |    3 +--
> arch/powerpc/platforms/8xx/m8xx_setup.c      |    1 -
> arch/powerpc/platforms/8xx/mpc86xads_setup.c |    2 --
> arch/powerpc/platforms/8xx/mpc885ads_setup.c |    2 --
> arch/powerpc/sysdev/commproc.c               |    1 -
> arch/powerpc/sysdev/commproc.h               |   12 ------------
> arch/powerpc/sysdev/mpc8xx_pic.c             |    1 -
> drivers/net/fs_enet/mac-scc.c                |    1 -
> include/asm-powerpc/commproc.h               |    2 ++
> include/asm-powerpc/mpc8xx.h                 |    7 +++++++

Do we really need the prototypes you moved into asm/mpc8xx.h here?   
can they just live in platforms/8xx/8xx.h or something like that?

- k

