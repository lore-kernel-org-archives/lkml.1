Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYJNGv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYJNGv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYJNGvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:51:21 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40485 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYJNGvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:51:20 -0400
Date: Tue, 14 Oct 2008 08:50:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: simplify string handling in elv_iosched_store()
Message-ID: <20081014065038.GN19428@kernel.dk>
References: <48F43D68.40300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F43D68.40300@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14 2008, Li Zefan wrote:
> strlcpy() guarantees the dest buffer is NULL teminated.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  block/elevator.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)

Applied, thanks

-- 
Jens Axboe

