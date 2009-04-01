Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbZDAJNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbZDAJNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbZDAJN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:13:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49185 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbZDAJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:13:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: add_to_swap_cache with GFP_ATOMIC ?
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh@veritas.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090401165516.B1EB.A69D9226@jp.fujitsu.com>
References: <Pine.LNX.4.64.0903311154570.19028@blonde.anvils> <20090401165516.B1EB.A69D9226@jp.fujitsu.com>
Message-Id: <20090401181236.B1F4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed,  1 Apr 2009 18:13:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IOW, GFP_ATOMIC on add_to_swap() was introduced accidentally. the reason 
> was old add_to_page_cache() didn't have gfp_mask parameter and we didn't
>  have the reason of changing add_to_swap() behavior.
> I think it don't have deeply reason and changing GFP_NOIO don't cause regression.

"accidentally" is wrong word obiously. I mean "non strong intention".


