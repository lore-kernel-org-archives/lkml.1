Return-Path: <linux-kernel-owner+w=401wt.eu-S934790AbYDQLQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbYDQLQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYDQLQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:16:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11151 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbYDQLQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:16:08 -0400
Date: Thu, 17 Apr 2008 13:16:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix race between disk-adding code and interrupt handler
Message-ID: <20080417111603.GD12774@kernel.dk>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net> <20080414170505.GO12774@kernel.dk> <20080414172716.GM16584@beardog.cca.cpqcorp.net> <20080414173720.GQ12774@kernel.dk> <20080414174540.GO16584@beardog.cca.cpqcorp.net> <20080414175219.GR12774@kernel.dk> <20080416185924.GP16584@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416185924.GP16584@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16 2008, scameron@beardog.cca.cpqcorp.net wrote:
> 
> Fix race condition between cciss_init_one(), cciss_update_drive_info(),
> and cciss_check_queues(). 

That's certainly belt and suspenders, but it's looking much better than
the previous version. Applied, thanks.

-- 
Jens Axboe

