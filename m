Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXFLLR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXFLLR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXFLLRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:17:19 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:55788 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbXFLLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:17:18 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] make mm/swap_prefetch.c:remove_from_swapped_list()  static
Date: Tue, 12 Jun 2007 21:16:04 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612110752.GW3588@stusta.de>
In-Reply-To: <20070612110752.GW3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706122116.04600.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 21:07, Adrian Bunk wrote:
> remove_from_swapped_list() can become static.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks. Good pick up. It was a global function but now is only done locally 
from within swap_prefetch.c lazily since the improvements.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

-- 
-ck
