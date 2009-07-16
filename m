Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZGPDR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZGPDR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZGPDR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:17:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757279AbZGPDR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:17:27 -0400
Date: Wed, 15 Jul 2009 20:16:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Message-Id: <20090715201654.550cb640.akpm@linux-foundation.org>
In-Reply-To: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
	<20090716095119.9D0A.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 09:52:34 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

>  	if (file)
> -		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
> +		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
>  	else
> -		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
> +		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);

we could have used __sub_zone_page_state() there.
