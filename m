Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYETJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYETJdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760765AbYETJdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:33:05 -0400
Received: from sacred.ru ([62.205.161.221]:51354 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYETJdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:33:03 -0400
Message-ID: <4832987A.2070801@openvz.org>
Date: Tue, 20 May 2008 13:23:06 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 2/3] memcg:: seq_ops support for cgroup
References: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com> <20080520180841.f292beef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080520180841.f292beef.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 20 May 2008 13:25:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Does anyone have a better idea ?
> ==
>  
> Currently, cgroup's seq_file interface just supports single_open.
> This patch allows arbitrary seq_ops if passed.

That's great :)

> For example, "status per cpu, status per node" can be very big
> in general and they tend to use its own start/next/stop ops.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
