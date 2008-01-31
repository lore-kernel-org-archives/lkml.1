Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbYAaIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbYAaIpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbYAaIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:45:30 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7503 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbYAaIpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:45:30 -0500
Date: Thu, 31 Jan 2008 09:45:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] io-scheduler : spinlock deadlock
Message-ID: <20080131084526.GJ15220@kernel.dk>
References: <20080131084345.GA3902@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131084345.GA3902@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008, Dave Young wrote:
> While building kernel, lockdep detected spinlock deaklock and after a
> while the system hung.
> 
> Attached is the screenshot.

Fixed by commit 149a051f82d2b3860fe32fa182dbc83a66274894 yesterday, just
updated your kernel.

-- 
Jens Axboe

