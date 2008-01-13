Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYAMUCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYAMUCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYAMUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:02:28 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:46465 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYAMUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:02:28 -0500
Message-ID: <478A6E36.1030309@cosmosbay.com>
Date: Sun, 13 Jan 2008 21:01:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: travis@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] x86: Change size of node ids from u8 to u16
References: <20080113183453.973425000@sgi.com> <20080113183454.288993000@sgi.com>
In-Reply-To: <20080113183454.288993000@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 13 Jan 2008 21:02:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

travis@sgi.com a écrit :
> Change the size of node ids from 8 bits to 16 bits to
> accomodate more than 256 nodes.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
> ---
>  arch/x86/mm/numa_64.c      |    9 ++++++---
>  arch/x86/mm/srat_64.c      |    2 +-
>  include/asm-x86/numa_64.h  |    4 ++--
>  include/asm-x86/topology.h |    2 +-
>  4 files changed, 10 insertions(+), 7 deletions(-)

So, you think some machine is going to have more than 256 nodes ?

If so, you probably need to change 'struct memnode' too 
(include/asm-x86/mmzone_64.h)


