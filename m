Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZJOBzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZJOBzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZJOBzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:55:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56805 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZJOBzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:55:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] mm: move inc_zone_page_state(NR_ISOLATED) to just isolated place
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>, stable@kernel.org
In-Reply-To: <20091013115957.e2871557.akpm@linux-foundation.org>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com> <20091013115957.e2871557.akpm@linux-foundation.org>
Message-Id: <20091015105154.C76A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Oct 2009 10:54:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri,  9 Oct 2009 10:06:58 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > This patch series is trivial cleanup and fix of page migration.
> > 
> > 
> > ==========================================================
> > 
> > Christoph pointed out inc_zone_page_state(NR_ISOLATED) should be placed
> > in right after isolate_page().
> 
> The bugfixes are appropriate for 2.6.32 and should be backported into
> -stable too, I think.  I haven't checked to see how long those bugs
> have been present.
> 
> The cleanup is more appropriate for 2.6.33 so I had to switch the order
> of these patches.  Hopefully the bugfixes were not dependent on the
> cleanup.  

Yes, each patches are independent.
[1/3] is cleanup.
[2/3] and [3/3] are bugfixes.

I'm sorry for lack of prudence of patch order.



