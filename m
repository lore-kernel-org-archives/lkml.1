Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbXFOOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbXFOOgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXFOOgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:36:25 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34726 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbXFOOgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:36:24 -0400
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <20070615120848.352093000@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
	 <20070615120848.352093000@pademelon.sonytel.be>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 15:35:59 +0100
Message-Id: <1181918159.25228.543.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 13:39 +0200, Geert Uytterhoeven wrote:
> Add a Disk Storage Driver for the PS3:
>   - Implemented as a block device driver with a dynamic major
>   - Disk names (and partitions) are of the format ps3d%c(%u)
>   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
>     doesn't support scatter-gather

Any particular reason why this is done as a separate block device driver
rather than as SCSI?

-- 
dwmw2

