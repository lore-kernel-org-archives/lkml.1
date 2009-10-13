Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZJMTBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZJMTBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZJMTBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:01:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbZJMTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:01:43 -0400
Date: Tue, 13 Oct 2009 11:59:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH 1/3] mm: move inc_zone_page_state(NR_ISOLATED) to just
 isolated place
Message-Id: <20091013115957.e2871557.akpm@linux-foundation.org>
In-Reply-To: <20091009100527.1284.A69D9226@jp.fujitsu.com>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Oct 2009 10:06:58 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> This patch series is trivial cleanup and fix of page migration.
> 
> 
> ==========================================================
> 
> Christoph pointed out inc_zone_page_state(NR_ISOLATED) should be placed
> in right after isolate_page().

The bugfixes are appropriate for 2.6.32 and should be backported into
-stable too, I think.  I haven't checked to see how long those bugs
have been present.

The cleanup is more appropriate for 2.6.33 so I had to switch the order
of these patches.  Hopefully the bugfixes were not dependent on the
cleanup.  

