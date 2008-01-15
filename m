Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYAOCHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYAOCHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYAOCHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:07:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33611 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYAOCHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:07:36 -0500
Date: Tue, 15 Jan 2008 11:10:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-Id: <20080115111035.d516639a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 10:01:21 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +	if (pressure) {
> +		nr_wakeup = max_t(int, atomic_read(&nr_watcher_task)>>4, 100);
> +		atomic_long_set(&last_mem_notify, jiffies);
> +		wake_up_locked_nr(&mem_wait, nr_wakeup);
> +	}
What is this for ? and Why ?
Are there too many waiters ?

Thanks
-Kame

