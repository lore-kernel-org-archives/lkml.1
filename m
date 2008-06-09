Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYFIAh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYFIAh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYFIAhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:37:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbYFIAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:37:21 -0400
Date: Mon, 09 Jun 2008 09:37:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] introduce sysctl of throttle
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080608130935.ea7076fc.akpm@linux-foundation.org>
References: <20080605021505.694195095@jp.fujitsu.com> <20080608130935.ea7076fc.akpm@linux-foundation.org>
Message-Id: <20080609093617.7865.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +int vm_max_nr_task_per_zone __read_mostly
> > +       = CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE;
> 
> It would be nice if we could remove
> CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE altogether.  Its a pretty obscure
> thing and we haven't provided people wait any information which would
> permit them to tune it anwyay.
> 
> In which case this patch should be folded into [4/5].

Sure.
I'll remove CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE Kconfig.

Thanks!


