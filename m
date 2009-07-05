Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZGELKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZGELKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZGELJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:09:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36303 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZGELJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:09:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/5] add per-zone statistics to show_free_areas()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090705110548.GA1898@localhost>
References: <20090705182259.08F6.A69D9226@jp.fujitsu.com> <20090705110548.GA1898@localhost>
Message-Id: <20090705200757.0911.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 20:09:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jul 05, 2009 at 05:23:35PM +0800, KOSAKI Motohiro wrote:
> > Subject: [PATCH] add per-zone statistics to show_free_areas()
> > 
> > Currently, show_free_area() mainly display system memory usage. but it
> > doesn't display per-zone memory usage information.
> > 
> > However, if DMA zone OOM occur, Administrator definitely need to know
> > per-zone memory usage information.
> 
> DMA zone is normally lowmem-reserved. But I think the numbers still
> make sense for DMA32.
> 
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Yes, x86_64 have DMA and DMA32, but almost 64-bit architecture have
2 or 4GB "DMA" zone.
Then, I wrote the patch description by generic name.

Thanks.


