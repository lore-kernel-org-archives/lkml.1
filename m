Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYEMNBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYEMNBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYEMNBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:01:22 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45392 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYEMNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:01:21 -0400
Message-Id: <482990FC.3020303@mxp.nes.nec.co.jp>
Date: Tue, 13 May 2008 22:00:44 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 05/15] free swap space on swap-in/activation
References: <20080428181835.502876582@redhat.com>	<20080428181852.620969450@redhat.com>	<4828283C.4000803@mxp.nes.nec.co.jp> <20080512093307.2ace3096@bree.surriel.com>
In-Reply-To: <20080512093307.2ace3096@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/05/12 22:33 +0900, Rik van Riel wrote:
> On Mon, 12 May 2008 20:21:32 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
>> So, the intention of this patch is
>> not to free a swap space of swap cache that has already swapped in
>> and only used one process as do_swap_page() does,
>> but to free a swap space that is only used as a swap cache
>> (not used by any processes), right?
> 
> No.  The code should also free the swap space of pages that are
> mapped by processes, in order to free up swap space for other
> uses.  This only happens if vm_swap_full() is true.
> 

OK.

I thought that current code cannot free the swap space
of pages that are mapped by processes(and I think it cannot),
so I asked the intention of this patch for clarification.


Thanks,
Daisuke Nishimura.

