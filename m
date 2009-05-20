Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZETOs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZETOs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZETOsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:48:21 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64195 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbZETOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:48:20 -0400
Message-ID: <4A141810.4020104@freescale.com>
Date: Wed, 20 May 2009 09:47:44 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Li Yang <leoli@freescale.com>, Wolfgang Denk <wd@denx.de>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       LKML List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash
 size
References: <1242155174-2513-1-git-send-email-wd@denx.de> <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com> <20090513194249.BA7D9832E416@gemini.denx.de> <156C2E1E-8E67-4358-B72E-4BB67D79C2AF@kernel.crashing.org>
In-Reply-To: <156C2E1E-8E67-4358-B72E-4BB67D79C2AF@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> Scott, any feedback if our boards have 8M or 32M flash modules?

According to the manual, it comes with 8 but can be expanded to 32.  I 
don't think we swapped out the flash SIMM that came with the board.

As I wrote earlier in the thread, I don't see any way a current u-boot 
would enable more than 8MiB of flash on this board anyway.  I'd go ahead 
and apply the patch.

-Scott
