Return-Path: <linux-kernel-owner+w=401wt.eu-S935757AbZLHBjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757AbZLHBjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935734AbZLHBjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:39:53 -0500
Received: from ozlabs.org ([203.10.76.45]:36809 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935443AbZLHBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:39:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@suse.de>
Subject: Re: [080/119] sched: Fix boot crash by zalloc()ing most of the cpu masks
Date: Tue, 8 Dec 2009 12:09:51 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Blanchard <anton@samba.org>
References: <20091206235936.208334321@mini.kroah.org> <20091207000654.821385285@mini.kroah.org>
In-Reply-To: <20091207000654.821385285@mini.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912081209.51984.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009 10:30:56 am Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> commit 49557e620339cb134127b5bfbcfecc06b77d0232 upstream.
> 
> I got a boot crash when forcing cpumasks offstack on 32 bit,
> because find_new_ilb() returned 3 on my UP system (nohz.cpu_mask
> wasn't zeroed).

Please also include "bdddd2963c0264c56f18043f6fa829d3c1d3d1c0"
(sched: Fix isolcpus boot option) from Linus' tree which fixes
a regression this introduces.

Thanks,
Rusty.
