Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYGDKu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYGDKu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYGDKut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:50:49 -0400
Received: from sacred.ru ([62.205.161.221]:41626 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYGDKus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:50:48 -0400
Message-ID: <486DFCF7.3010104@openvz.org>
Date: Fri, 04 Jul 2008 14:35:35 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH 2/2] memcg: check limit change
References: <20080704181204.44070413.kamezawa.hiroyu@jp.fujitsu.com> <20080704181606.4e9187e7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080704181606.4e9187e7.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 04 Jul 2008 14:37:59 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Shrinking memory usage at limit change.
> 
> Changelog: v1 -> v2
>   - adjusted to be based on write_string() patch set
>   fixed pointed out styles (below)
>   - removed backword goto.
>   - removed unneccesary cond_resched().
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
