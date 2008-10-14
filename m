Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYJNQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYJNQad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYJNQaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:30:22 -0400
Received: from elvis.franken.de ([193.175.24.41]:50267 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYJNQaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:30:21 -0400
Date: Tue, 14 Oct 2008 18:30:07 +0200
To: Julia Lawall <julia@diku.dk>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       sammy@sammy.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/scsi/sun3x_esp.c: Convert && to ||
Message-ID: <20081014163007.GA9015@alpha.franken.de>
References: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 06:00:19PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The pattern !E && !E->fld is nonsensical.  The patch below updates this
> according to the assumption that && should be ||.  But perhaps another
> solution was intended.

Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thanks for fixing this.
Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
