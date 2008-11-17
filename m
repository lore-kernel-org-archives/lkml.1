Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYKQMN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYKQMN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYKQMNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:13:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43697 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbYKQMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:13:19 -0500
Date: Mon, 17 Nov 2008 13:11:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] cdrom: split mmc_ioctl to lower stack usage
Message-ID: <20081117121134.GM26778@kernel.dk>
References: <20081116180437.GC6282@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116180437.GC6282@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16 2008, Marcin Slusarz wrote:
> Checkstack output:
> 
> Before:
> mmc_ioctl:                  584
> 
> After:
> mmc_ioctl_dvd_read_struct:  280
> mmc_ioctl_cdrom_subchannel: 152
> mmc_ioctl_cdrom_read_data:  120
> mmc_ioctl_cdrom_volume:     104
> mmc_ioctl_cdrom_read_audio: 104
> (mmc_ioctl is inlined into cdrom_ioctl - 104 bytes)

Looks good (both 1 and 2). What kind of testing have you done? I have
applied it to for-2.6.29.

-- 
Jens Axboe

