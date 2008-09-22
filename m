Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYIVT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYIVT7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYIVT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:59:11 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:40352 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbYIVT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:59:10 -0400
Date: Mon, 22 Sep 2008 21:58:59 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: liam.girdwood@wolfsonmicro.com, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Fix at32-pcm build breakage with PM enabled
Message-ID: <20080922215859.2e5a3d85@siona.skinnemoen.net>
In-Reply-To: <s5hhc88xz5p.wl%tiwai@suse.de>
References: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com>
 <s5hhc88xz5p.wl%tiwai@suse.de>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2008 19:58:49.0302 (UTC) FILETIME=[A122F760:01C91CED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 12:17:38 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> At Fri, 19 Sep 2008 18:50:45 +0200,
> Haavard Skinnemoen wrote:
> > 
> > s/PDC_PTCR/ATMEL_PDC_PTCR/  
> 
> We have also SSC_PDC_PTCR there.
> Maybe better to unify them, too?

Yes...I was sort of wondering about that...

It's probably best to get rid of SSC_PDC_PTCR and friends and use the
common definitions from include/linux/atmel_pdc.h.

Haavard
