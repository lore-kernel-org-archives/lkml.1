Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbXJYJwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbXJYJwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbXJYJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbXJYJwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:52:07 -0400
Date: Thu, 25 Oct 2007 11:52:05 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, willy@linux.intel.com
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
Message-ID: <20071025095205.GB22353@pingi.kke.suse.de>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
	akpm@linux-foundation.org, willy@linux.intel.com
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:06:15AM -0400, Jeff Garzik wrote:
> These two warnings...
> 
> drivers/isdn/capi/capidrv.c:2126:3: warning: #warning FIXME: maybe a
> race condition the card should be removed here from global list /kkeil
> 
> drivers/scsi/advansys.c:71:2: warning: #warning this driver is still
> not properly converted to the DMA API
> 
> ...represent conditions that have existed for years, and are duly noted
> in FIXMEs.  There does not seem to be much need to warn on every kernel
> build for a driver bug or handicap that has existed for years.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/isdn/capi/capidrv.c |    3 ++-

Acked.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
