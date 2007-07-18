Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbXGRKCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbXGRKCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbXGRKCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:02:05 -0400
Received: from stinky.trash.net ([213.144.137.162]:34080 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbXGRKCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:02:03 -0400
Message-ID: <469DE502.8070800@trash.net>
Date: Wed, 18 Jul 2007 12:01:38 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: rae l <crquan@gmail.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [net/core] move dev_mc_discard from dev_mcast.c to
 dev.c
References: <11846606051099-git-send-email-crquan@gmail.com>	 <11847264651509-git-send-email-crquan@gmail.com>	 <20070718.021107.40833440.davem@davemloft.net> <91b13c310707180259v547ba2b3wc901102d35760a50@mail.gmail.com>
In-Reply-To: <91b13c310707180259v547ba2b3wc901102d35760a50@mail.gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rae l wrote:
> All in one word, I don't think the single file dev_mcast.c is needed
> anymore.


Agreed. But dev.c is growing larger and larger, maybe dev_addr.c?
Or dev_config.c, with some of the other device configuration functions?
