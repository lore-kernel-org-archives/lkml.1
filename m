Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZGGQhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZGGQhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZGGQhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:37:40 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46114 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753445AbZGGQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:37:39 -0400
Date: Tue, 7 Jul 2009 12:37:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/5] Show kernel stack usage to /proc/meminfo and OOM
 log
In-Reply-To: <20090705182409.08FC.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907071234070.5124@gentwo.org>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com> <20090705182409.08FC.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, KOSAKI Motohiro wrote:

> Subject: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
>
> if the system have a lot of thread, kernel stack consume unignorable large size
> memory. IOW, it make a lot of unaccountable memory.
> Tons unaccountable memory bring to harder analyse memory related trouble.
>
> Then, kernel stack account is useful.

The amount of memory allocated to kernel stacks can become significant and
cause OOM conditions. However, we do not display the amount of memory
consumed by stacks.'

Add code to display the amount of memory used for stacks in /proc/meminfo.

Reviewed-by: <cl@linux-foundation.org>

(It may be useful to also include the stack sizes in the per zone
information displayed when an OOM occurs).
