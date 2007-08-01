Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXHAVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXHAVE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbXHAVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:03:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:58246 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXHAVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aJYyxcJauGkrjeCRGYNlo3VIoTX88gfOXo5fKZ7Ja1TqAI7eoIg4hRQssp5E6GU/Yqv9JUDMfSKIPvPiopvJCkcImiGcp2rRtySLPkXicR76vSt2Zu8AKBeSJysKFnclBv/WhnzBwGSfJMwEg7BEOP+77W2pVRq2FuOhEQWHl1A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Eliminate warnings in ide-tape.c
Date: Wed, 1 Aug 2007 22:49:52 +0200
User-Agent: KMail/1.9.6
Cc: Gadi Oxman <gadio@netvision.net.il>, LKML <linux-kernel@vger.kernel.org>
References: <20070730144227.a002faf3.sfr@canb.auug.org.au>
In-Reply-To: <20070730144227.a002faf3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012249.52843.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2007, Stephen Rothwell wrote:
> drivers/ide/ide-tape.c: In function '__idetape_kmalloc_stage':
> drivers/ide/ide-tape.c:2588: warning: large integer implicitly truncated to unsigned type
> drivers/ide/ide-tape.c:2616: warning: large integer implicitly truncated to unsigned type
> 
> b_size in struct idetape_bh is an unsigned short.  We sometimes assigne
> PAGE_SIZE to it and PAGE_SIZE can be 64K or larger, so make it a u32.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

applied
