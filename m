Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZGWO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZGWO52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZGWO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:57:28 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:62189 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbZGWO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:57:27 -0400
From: Frans Pop <elendil@planet.nl>
To: Jens Rosenboom <jens@leia.mcbone.net>
Subject: Re: early_ioremap messages with old ASUS board
Date: Thu, 23 Jul 2009 16:57:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <1248351634.7237.32.camel@fnki-nb00130>
In-reply-To: <1248351634.7237.32.camel@fnki-nb00130>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907231657.26690.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 14:57:26.0997 (UTC) FILETIME=[E4D23050:01CA0BA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Rosenboom wrote:
> Running 2.6.31-rc4 I get the following dmesg output:
>
> [ 0.000000] early_ioremap(000f0000, 00010000) [0] => Pid: 0, comm:
> swapper Not tainted 2.6.31-rc4 #36
> [ 0.000000] Call Trace:
> [ 0.000000]  [<c136e48b>] ? printk+0x18/0x1d
> [ 0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
> [ 0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
> [ 0.000000]  [<c156194e>] dmi_scan_machine+0x1a/0x1af
> [ 0.000000]  [<c15404c5>] ? parse_early_options+0x23/0x25
> [ 0.000000]  [<c1543d92>] setup_arch+0x3d0/0x922
> [ 0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
> [ 0.000000]  [<c1540897>] start_kernel+0x77/0x2da
> [ 0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
> [ 0.000000] 00000000 + ffe00000

Did .31-rc3 work correctly?

If it did, then could you try if reverting commit 857fdc53a0a9 helps?
It's a bit of a wild guess, but it solved an iomem change on my notebook.

Cheers,
FJP
