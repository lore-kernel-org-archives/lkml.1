Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZGIUqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZGIUqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZGIUqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:46:42 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38247 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753826AbZGIUql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:46:41 -0400
Date: Thu, 9 Jul 2009 16:46:36 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 5/5] add shmem vmstat
In-Reply-To: <20090709171452.23C9.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907091643240.17835@gentwo.org>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709171452.23C9.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, KOSAKI Motohiro wrote:

> Recently, We faced several OOM problem by plenty GEM cache. and generally,
> plenty Shmem/Tmpfs potentially makes memory shortage problem.

"
Recently we encountered OOM problems due to memory use of the GEM cache.
Generally a large amuont of Shmem/Tmpfs pages tend to create a memory
shortage problem.
"

> We often use following calculation to know shmem pages,
>   shmem = NR_ACTIVE_ANON + NR_INACTIVE_ANON - NR_ANON_PAGES
> but it is wrong expression. it doesn't consider isolated page and
> mlocked page.

"
We often use the following calculation to determine the amount of shmem
pages:

shmem = NR_ACTIVE_ANON + NR_INACTIVE_ANON - NR_ANON_PAGES

however the expression does not consider isoalted and mlocked pages.
"

> Then, This patch make explicit Shmem/Tmpfs vm-stat accounting.

"
This patch adds explicit accounting for pages used by shmem and tmpfs.
"

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

