Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZEZGwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZEZGwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZEZGwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:52:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38783 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZEZGwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:52:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH][mmtom] clean up once printk routine
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
References: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
Message-Id: <20090526155155.6871.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 May 2009 15:52:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> == CUT HERE ==
> 
> There are some places to be able to use printk_once instead of hard coding.
> 
> It will help code readability and maintenance.
> This patch doesn't change function's behavior.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> CC: Dominik Brodowski <linux@dominikbrodowski.net>
> CC: David S. Miller <davem@davemloft.net>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/common.c  |    8 ++------
>  drivers/net/3c515.c           |    7 ++-----
>  drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
>  3 files changed, 7 insertions(+), 17 deletions(-)

Please separete to three patches ;)



