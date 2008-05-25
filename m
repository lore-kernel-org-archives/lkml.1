Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYEYPkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYEYPkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYEYPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:40:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57392 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYEYPkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:40:43 -0400
Date: Sun, 25 May 2008 17:40:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Francis Moreau <francis.moro@gmail.com>
cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: question about splice performance
In-Reply-To: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805251736400.19084@fbirervta.pbzchgretzou.qr>
References: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-05-25 17:12, Francis Moreau wrote:

>Hi,
>
>I did a really basic benchmark and was suprise about the results.
>
>$ echo 3 > /proc/sys/vm/drop_caches
>$ time  splice-cp  vmlinux /tmp/vmlinux
>
>real    0m10.158s
>user    0m0.002s
>sys     0m0.401s
>
>$ echo 3 > /proc/sys/vm/drop_caches
>$ time  cp  vmlinux /tmp/vmlinux
>
>real    0m10.590s
>user    0m0.017s
>sys     0m0.459s
>
>
>I was expecting splice-cp case to be faster.
>
>Could someone enlight me ?

Slow disk outweighs memory copying overhead. And 300 MB is quickly
transferred in idle systems.
