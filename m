Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0CAVPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:15:31 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59853 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0CAVP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:15:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5907"; a="35197051"
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100301211057.GA3004@elf.ucw.cz>
References: <1263914079.1951.43.camel@m0nster>
	 <20100131084421.GG2238@elf.ucw.cz> <20100131092829.GJ2238@elf.ucw.cz>
	 <1264953492.2059.5.camel@m0nster> <20100225193027.GA7391@elf.ucw.cz>
	 <1267126586.5439.56.camel@c-dwalke-linux.qualcomm.com>
	 <20100225194125.GA7645@elf.ucw.cz>
	 <1267127298.5439.62.camel@c-dwalke-linux.qualcomm.com>
	 <20100226213107.GA29615@elf.ucw.cz>
	 <1267469856.29769.9.camel@c-dwalke-linux.qualcomm.com>
	 <20100301211057.GA3004@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 13:15:18 -0800
Message-ID: <1267478118.29769.16.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 22:10 +0100, Pavel Machek wrote:

> How do I get that one? I tried killing the repository and redoing git
> pull, followed up by 

You should just be able to do "git remotes update" , then checkout the
branch again.

> git checkout refs/remotes/origin/working-mmc
> 
> only to get (git log): [I think I was there before].
> 
> commit 2b0bcf161e83fc7d45476f3330f06b656a1f03d4
> Author: Daniel Walker <dwalker@codeaurora.org>
> Date:   Mon Feb 22 12:29:17 2010 -0800
> 
>     DMA fixes (get MMC working).
> 
> commit 5fc33446739aa7a0826d98a00cc50a712c6d60eb
> Author: San Mehat <san@google.com>
> Date:   Wed Feb 3 12:59:29 2010 -0800
> 
>     drivers: mmc: msm_sdcc: Add EMBEDDED_SDIO support
>     
>     Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

I actually dropped a patch between the two above, otherwise the history
is very similar. I think you have the right one, are you still getting
the compile errors?

Daniel

