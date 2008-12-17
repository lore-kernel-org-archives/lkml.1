Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752633AbYLQQk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYLQQk3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYLQQkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:40:11 -0500
Received: from gw.goop.org ([64.81.55.164]:53254 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYLQQkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:40:10 -0500
Message-ID: <49492B68.7040509@goop.org>
Date: Wed, 17 Dec 2008 08:40:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com
Subject: Re: [PATCH 04 of 14] swiotlb: consistently use address_needs_mapping
 everywhere
References: <patchbomb.1229458644@abulafia.goop.org>	<aba0c734944520d4b892.1229458648@abulafia.goop.org> <20081217113804F.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081217113804F.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 16 Dec 2008 12:17:28 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> ---
>>  lib/swiotlb.c |   10 +++-------
>>  1 file changed, 3 insertions(+), 7 deletions(-)
>>     
>
> This patch is wrong.
>
> dma_mask and coherent_dma_mask represent different restrictions.
>
> You can't use coherent_dma_mask for alloc_coherent.
>   

OK.  It looks like this patch is just an (erroneous) cleanup, so we can 
drop it.

    J
