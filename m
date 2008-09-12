Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYILKPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYILKPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYILKPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:15:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40872 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYILKPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:15:36 -0400
Date: Fri, 12 Sep 2008 19:18:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 0/9]  remove page_cgroup pointer (with some
 enhancements)
Message-Id: <20080912191828.58657b03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080912183540.6e7d2468.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080912183540.6e7d2468.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 18:35:40 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Execl Throughput                           3064.9 lps   (29.8 secs, 3 samples)
> C Compiler Throughput                       998.0 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               4717.0 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)                928.3 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               474.3 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         127184.0 lpm   (30.0 secs, 3 samples)
> 
This number is because of BUG. follwoing is fixed one.

Execl Throughput                           3026.0 lps   (29.8 secs, 3 samples)
C Compiler Throughput                       971.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               4573.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)                913.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               465.7 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         125412.1 lpm   (30.0 secs, 3 samples)

not good yet ;(  Very sorry for noise.
-Kame

