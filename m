Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYEGOWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYEGOWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbYEGOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:22:32 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:48181 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbYEGOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:22:30 -0400
Message-ID: <4821BB0E.80000@freescale.com>
Date: Wed, 07 May 2008 09:22:06 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: benh@kernel.crashing.org, alsa-devel@alsa-project.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ALSA vs. non coherent DMA
References: <1210032508.21644.129.camel@pasglop> <s5hmyn3d7d5.wl%tiwai@suse.de>
In-Reply-To: <s5hmyn3d7d5.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:

> This is a mmap of the data record to be shared in realtime with apps.
> The app updates its data pointer (appl_ptr) on the mmapped buffer
> while the driver updates the data (e.g. DMA position, called hwptr) on
> the fly on the mmapped record.  Due to its real-time nature, it has to
> be coherent -- at least, it was a problem on ARM.

This doesn't sound like a coherency problem to me, and least not one you'd find
on PowerPC.  Both the driver and the application run on the host CPU, so there
shouldn't be any coherency problem.  My understanding is that a "non coherent"
platform is one where the host CPU isn't aware when a *hardware device* writes
directly to memory, e.g. via DMA.

-- 
Timur Tabi
Linux kernel developer at Freescale
