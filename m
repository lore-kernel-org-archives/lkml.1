Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYGRFrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYGRFrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGRFq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:46:56 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:37322 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYGRFqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:46:55 -0400
Date: Fri, 18 Jul 2008 09:46:26 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Message-ID: <20080718054626.GA3338@2ka.mipt.ru>
References: <20080717214222.GA29449@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717214222.GA29449@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

On Thu, Jul 17, 2008 at 11:42:22PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> Pid: 5098, comm: gdm-binary Not tainted 2.6.26-tip #3094
>  [<c0186f99>] print_trailer+0xa9/0xf0
>  [<c018707b>] check_bytes_and_report+0x9b/0xc0
>  [<c01874ae>] check_object+0x19e/0x1e0
>  [<c0187ef1>] __slab_alloc+0x371/0x4e0
>  [<c0188552>] kmem_cache_alloc+0xb2/0xc0
>  [<c06732dc>] ? __alloc_skb+0x2c/0x110

Out of curiosity, why does it scream at allocation time?
Does SLUB have a debug check at freeing time? If so, how does it work
and why didn't it caught use after free there?

-- 
	Evgeniy Polyakov
