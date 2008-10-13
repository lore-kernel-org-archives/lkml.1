Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYJMG7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYJMG7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYJMG67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:58:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:45734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYJMG67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:58:59 -0400
Message-ID: <48F2F138.6020103@kernel.org>
Date: Mon, 13 Oct 2008 15:56:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Jeff Garzik <jgarzik@pobox.com>, Li Yang <leoli@freescale.com>,
       Wang Jian <lark@linux.net.cn>, "Steven A. Falco" <sfalco@harris.com>,
       linuxppc-dev@ozlabs.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
In-Reply-To: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Oct 2008 06:58:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> When no irq specified the pata_of_platform fills the irq_res with -1,
> which is wrong to do for two reasons:
> 
> 1. By definition, 'no irq' should be IRQ 0, not some negative integer;
> 2. pata_platform checks for irq_res.start > 0, but since irq_res.start
>    is unsigned type, the check will be true for `-1'.
> 
> Reported-by: Steven A. Falco <sfalco@harris.com>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

applied to #tj-upstream (will soon be sent upstream)

-- 
tejun
