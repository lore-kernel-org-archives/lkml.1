Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274Ab0AGWFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0AGWFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651Ab0AGWFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:05:05 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51277 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0AGWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:05:04 -0500
Date: Thu, 7 Jan 2010 16:04:00 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] Allow CONFIG_MIGRATION to be set without
 CONFIG_NUMA
In-Reply-To: <alpine.DEB.2.00.1001071331520.23894@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1001071603260.6864@router.home>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-2-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071331520.23894@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 Jan 2010, David Rientjes wrote:

> CONFIG_MIGRATION is no longer strictly dependent on CONFIG_NUMA since
> ARCH_ENABLE_MEMORY_HOTREMOVE has allowed it to be configured for UMA
> machines.  All strictly NUMA features in the migration core should be
> isolated under its #ifdef CONFIG_NUMA (sys_move_pages()) in mm/migrate.c
> or by simply not compiling mm/mempolicy.c (sys_migrate_pages()), so this
> patch looks fine as is (although the "help" text for CONFIG_MIGRATION
> could be updated to reflect that it's useful for both memory hot-remove
> and now compaction).

Correct.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
