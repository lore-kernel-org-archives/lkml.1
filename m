Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYIAJQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYIAJQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYIAJQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:16:32 -0400
Received: from sacred.ru ([62.205.161.221]:34042 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYIAJQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:16:32 -0400
Message-ID: <48BBAE08.1040804@openvz.org>
Date: Mon, 01 Sep 2008 12:55:36 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] res_counter: fix off-by-one bug in setting limit
References: <48BB78E7.5080001@cn.fujitsu.com>
In-Reply-To: <48BB78E7.5080001@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 01 Sep 2008 12:55:34 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> I found we can no longer set limit to 0 with 2.6.27-rcX:
>  # mount -t cgroup -omemory xxx /mnt
>  # mkdir /mnt/0
>  # echo 0 > /mnt/0/memory.limit_in_bytes
>  bash: echo: write error: Device or resource busy
> 
> It turned out 'limit' can't be set to 'usage', which is wrong IMO.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
