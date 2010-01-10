Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436Ab0AJPVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0AJPVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 10:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238Ab0AJPVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 10:21:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18718 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0AJPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 10:21:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5856"; a="31728433"
Subject: Re: trouble compiling dwalker's for-next tree
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
In-Reply-To: <20100109085106.GA23290@elf.ucw.cz>
References: <20100109085106.GA23290@elf.ucw.cz>
Content-Type: text/plain
Date: Sun, 10 Jan 2010 07:19:05 -0800
Message-Id: <1263136745.2446.13.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 09:51 +0100, Pavel Machek wrote:
> Hi!
> 
> It is great to have all changes merged, but I ran into some trouble:
> 
> 1) mmc.h was missing.
> 
> 2)   CC      arch/arm/mach-msm/rpc_hsusb.o
> arch/arm/mach-msm/rpc_hsusb.c: In function 'msm_chg_rpc_connect':
> arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> function 'machine_is_msm7201a_surf'
> arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> function 'machine_is_msm7x27_surf'
> arch/arm/mach-msm/rpc_hsusb.c:157: error: implicit declaration of
> function 'machine_is_qsd8x50_surf'
> make[1]: *** [arch/arm/mach-msm/rpc_hsusb.o] Error 1
> 
> (I provided missing inlines)
> 
> 3)   CC      arch/arm/mach-msm/acpuclock.o
> arch/arm/mach-msm/acpuclock.c:31:35: error: linux/remote_spinlock.h:
> No such file or directory
> arch/arm/mach-msm/acpuclock.c:106: error: expected '=', ',', ';',
> 'asm' or '__attribute__' before 'pll_lock'
> 

It's still really really un-cooked .. There's tons of compile failures
that still need to be cleanup .. Most of the targets aren't going to
compile without tuning the config some..

What config are you using? I can try to correct some of the compile
failure ..

Daniel

