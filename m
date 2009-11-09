Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZKIJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZKIJk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZKIJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:40:56 -0500
Received: from smtp.nokia.com ([192.100.122.230]:42475 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZKIJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:40:55 -0500
Subject: Re: [PATCH] txx9ndfmc: Use nand_release() to free resources
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1257172848-6282-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1257172848-6282-1-git-send-email-anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 11:40:38 +0200
Message-Id: <1257759638.21596.233.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Nov 2009 09:40:42.0577 (UTC) FILETIME=[B4549410:01CA6120]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 23:40 +0900, Atsushi Nemoto wrote:
> This patch fixes memory leak on chip->bbt and chip->buffers.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
>  drivers/mtd/nand/txx9ndfmc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Taken to the l2-mtd-2.6 tree, thanks. 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

