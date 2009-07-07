Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZGGQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZGGQrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZGGQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:47:15 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43530 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754669AbZGGQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:47:14 -0400
Date: Tue, 7 Jul 2009 12:46:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
In-Reply-To: <20090705182451.08FF.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907071238570.5124@gentwo.org>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com> <20090705182451.08FF.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, KOSAKI Motohiro wrote:

>  mm/vmstat.c            |    2 +-
>  6 files changed, 14 insertions(+), 3 deletions(-)
>
> Index: b/fs/proc/meminfo.c
> ===================================================================
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -65,6 +65,7 @@ static int meminfo_proc_show(struct seq_
>  		"Active(file):   %8lu kB\n"
>  		"Inactive(file): %8lu kB\n"
>  		"Unevictable:    %8lu kB\n"
> +		"IsolatedPages:  %8lu kB\n"

Why is it called isolatedpages when we display the amount of memory in
kilobytes?

