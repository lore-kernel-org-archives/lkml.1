Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYLCHV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYLCHV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYLCHVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:21:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58648 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYLCHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:21:20 -0500
Date: Wed, 3 Dec 2008 16:20:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "wassim dagash" <wassim.dagash@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KSWAPD Algorithm - 100% CPU
Message-Id: <20081203162025.c2ed83b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cb94e63d0812022304x49dfe519if4f8a8572a396672@mail.gmail.com>
References: <cb94e63d0812022304x49dfe519if4f8a8572a396672@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 09:04:49 +0200
"wassim dagash" <wassim.dagash@gmail.com> wrote:

> Hi All,
> Description:
> I countered a weird problem with kswapd:
> it runs in some infinite loop trying to swap until order 10 of zone
> highmem is OK, While zone higmem (as I understand) has nothing to do
> with contiguous memory (cause there is no 1-1 mapping) which means
> kswapd will continue to try to balance order 10 of zone highmem
> forever (or until someone release a very large chunk of highmem).
> Can anyone please explain me the algorithm of kswapd and why it tries
> to balance order 10 of zone higmem ?
> 
At first, what version of the kernel ?

-Kame

