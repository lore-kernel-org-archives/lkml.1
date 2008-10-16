Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYJPGZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYJPGZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYJPGZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:25:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51777 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbYJPGZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:25:48 -0400
Date: Thu, 16 Oct 2008 08:25:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: how to limit number of sectors each time
Message-ID: <20081016062503.GT19428@kernel.dk>
References: <48F6B51B.2000408@alcatel-lucent.com> <20081016054400.GN19428@kernel.dk> <48F6DA7A.9080003@alcatel-lucent.com> <20081016061808.GS19428@kernel.dk> <48F6DD54.70004@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6DD54.70004@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16 2008, gshan wrote:
> 
> >(please never send out html only emails, it's considered very bad style
> >on this list)
> >
> >Sounds like you need a quirk/blacklist entry for that drive, if it
> >doesn't support 0x00 as meaning 256 sectors. If you are using libata,
> >you can add a ATA_HORKAGE_MAX_SEC_128 entry to ata_device_blacklist[] in
> >drivers/ata/libata-core.c
> >  
> I'm using IDE driver instead of HD driver.

Then I'm sure Bart can help you out (CC'ed).

-- 
Jens Axboe

