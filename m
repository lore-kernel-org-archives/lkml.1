Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbZEMLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbZEMLJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZEMLJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:09:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46484 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZEMLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:09:34 -0400
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
From: Andi Kleen <andi@firstfloor.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
Date: Wed, 13 May 2009 13:09:32 +0200
In-Reply-To: <20090513172904.7234.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's message of "Wed, 13 May 2009 17:30:45 +0900 (JST)")
Message-ID: <87r5ytl0nn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
>
> Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
> used only embedded people.
> Thus, moving it into embedded submenu is better.

Is there are any reason it cannot be just made unconditional unless 
CONFIG_MMU is disabled. It was never clear to me why this was a config
option at all.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
