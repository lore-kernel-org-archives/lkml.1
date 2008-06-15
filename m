Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYFOG00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYFOG00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 02:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYFOG0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 02:26:18 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44216 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751436AbYFOG0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 02:26:17 -0400
Message-ID: <4854B604.6080900@davidnewall.com>
Date: Sun, 15 Jun 2008 15:56:12 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] 8139too: different style cleanups
References: <4853BB7B.4030905@freemail.hu> <48541173.7040905@freemail.hu>
In-Reply-To: <48541173.7040905@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
>  #  define DPRINTK(fmt, args...) \
> -	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
> +	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
>   

Why change __FUNCTION__ to __func__?  I don't even know where __func__
come from?  Assuming that it isn't totally broken, and I'll believe that
it isn't, then would it be compiler-specific?   __FUNCTION__ is standard
and that's more than enough reason to prefer that form to any
non-standard variation.


Yes to the following; no to all the rest:

> -#define RTL8139_CAPS	HAS_CHIP_XCVR|HAS_LNK_CHNG
> +#define RTL8139_CAPS	(HAS_CHIP_XCVR|HAS_LNK_CHNG)

