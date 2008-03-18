Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYCRKVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYCRKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 06:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYCRKU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 06:20:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58728 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYCRKU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 06:20:56 -0400
Date: Tue, 18 Mar 2008 19:25:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] Block I/O tracking
Message-Id: <20080318192541.54cc1a7d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080318.182508.103216251.taka@valinux.co.jp>
References: <20080318.182251.93858044.taka@valinux.co.jp>
	<20080318.182508.103216251.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 18:25:08 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:

> Hi,
> 
> This patch splits the cgroup memory subsystem into two parts.
> One is for tracking which cgroup which pages and the other is
> for controlling how much amount of memory should be assigned to
> each cgroup.
> 
> With this patch, you can use the page tracking mechanism even if
> the memory subsystem is off.
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> 
I think current my work, radix-tree page cgroup will help this work.
It creates page_cgroup.h and page_cgroup.c.
Patches are posted last week to the mm-list.(And now rewriting..)
Please let me know if you have requests.

Thanks,
-Kame


