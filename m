Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbYD3Ra5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbYD3Ra5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbYD3Rar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:30:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49618 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbYD3Raq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:30:46 -0400
Date: Wed, 30 Apr 2008 19:30:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: Improved Swapping Method In sort.c
In-Reply-To: <988568.21908.qm@web94102.mail.in2.yahoo.com>
Message-ID: <alpine.LNX.1.10.0804301929360.5623@fbirervta.pbzchgretzou.qr>
References: <988568.21908.qm@web94102.mail.in2.yahoo.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-04-30 19:09, Soumyadip Das Mahapatra wrote:

>Hello everybody, The swapping method (in function void u32_swap() line no.. 14
>to 16) in lib/sort.c can be improved by using the following code *(u32 *)b ^=
>*(u32 *)a ^= *(u32 *)b ^= *(u32 *)a instead of the code given.

GCC is smart enough to optimize the current instructions into a
bswap instruction or similar. While with xor, some are said to fail -
and three xor operations are surely slower than a swap if there is
a swap instruction.

Never heard of that?
