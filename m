Return-Path: <linux-kernel-owner+w=401wt.eu-S936367AbXGMJ4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936367AbXGMJ4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762139AbXGMJz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:55:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39020 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760319AbXGMJzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:55:55 -0400
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
From: David Woodhouse <dwmw2@infradead.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070713034822.GA2370@localhost.localdomain>
References: <20070712150135.GA4102@localhost.localdomain>
	 <1184256718.32199.111.camel@weaponx.rchland.ibm.com>
	 <20070713034822.GA2370@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 10:56:42 +0100
Message-Id: <1184320602.2785.18.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 11:48 +0800, WANG Cong wrote:
>                 if(map_banks[idx] == NULL) {
>                         ret = -ENOMEM;
> -                       /* FIXME: What if some MTD devices were probed already? */
> +                       /* FIXME: What if some MTD devices were probed
> +                       already? */
>                         goto error_mem;
>                 } 


That's just horrid. Leave it as it was.

-- 
dwmw2

