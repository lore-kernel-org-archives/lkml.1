Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYD2HhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYD2HhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYD2HhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:37:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6080 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbYD2HhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:37:07 -0400
Date: Tue, 29 Apr 2008 09:37:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Message-ID: <20080429073704.GB12774@kernel.dk>
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk> <4811BDBB.8010604@hp.com> <4811CBBC.4000206@hp.com> <4815FCF9.5060109@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815FCF9.5060109@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28 2008, Alan D. Brunelle wrote:
> Jens -
> 
> Would you consider taking in a patch set that had the tunable + enabled
> one-hit cache tries only? I don't see where the back-merge attempts add
> anything in a truly random case.
> 

Yep, I'm fine with that. Back merging wont help on truly random of
course, but it may make the switch more appealing to half-random cases
as well. But lets just go with a switch that turns off all search
merging and only keeps the one-hit cache.

-- 
Jens Axboe

