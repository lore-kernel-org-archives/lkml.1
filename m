Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbXHXJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbXHXJXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbXHXJXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:23:06 -0400
Received: from mail.suse.de ([195.135.220.2]:49791 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXHXJXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:23:05 -0400
Date: Fri, 24 Aug 2007 11:23:02 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       isdn4linux@listserv.isdn4linux.de,
       Michael Hipp <Michael.Hipp@student.uni-tuebingen.de>
Subject: Re: [PATCH 17/30] isdn: Get rid of some pointless allocation casts in common and bsd comp.
Message-ID: <20070824092302.GB19666@pingi.kke.suse.de>
Mail-Followup-To: Jesper Juhl <jesper.juhl@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kai Germaschewski <kai.germaschewski@gmx.de>,
	isdn4linux@listserv.isdn4linux.de,
	Michael Hipp <Michael.Hipp@student.uni-tuebingen.de>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <85cd9d8df6b94f6dbf4842a4b2aabe05737a3b46.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85cd9d8df6b94f6dbf4842a4b2aabe05737a3b46.1187912217.git.jesper.juhl@gmail.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 02:09:34AM +0200, Jesper Juhl wrote:
> vmalloc() returns a void pointer - no need to cast the return value.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Karsten Keil <kkeil@suse.de>
> ---
>  drivers/isdn/i4l/isdn_bsdcomp.c |    5 ++---
>  drivers/isdn/i4l/isdn_common.c  |    2 +-
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
...
-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
