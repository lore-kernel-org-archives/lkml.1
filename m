Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYIDMfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYIDMfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYIDMff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:35:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48832 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYIDMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:35:34 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: warning on device removal
Date: Thu, 4 Sep 2008 14:36:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080904122022.GA550@doriath.ww600.siemens.net>
In-Reply-To: <20080904122022.GA550@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041436.49083.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 04 September 2008 14:20:22 schrieb Dmitry Baryshkov:
> Hi,
> 
> I've got the following trace on one of my arm boards when removing
> the usb masstorage device:
> 
> ------------[ cut here ]------------
> WARNING: at /home/lumag/tosa-tree/arch/arm/mm/consistent.c:368 dma_free_coherent+0x34/0x248()
> Modules linked in:
> [<c0028fe4>] (dump_stack+0x0/0x14) from [<c003c810>] (warn_on_slowpath+0x4c/0x84)
> [<c003c7c4>] (warn_on_slowpath+0x0/0x84) from [<c0029e54>] (dma_free_coherent+0x34/0x248)

Looks like a principal problem we have with that architecture.
Is arm incapable of supporting buffer freeing in hard irq context
or do we use the wrong API?

	Regards
		Oliver

