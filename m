Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYENNd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYENNd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762159AbYENNco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:32:44 -0400
Received: from sacred.ru ([62.205.161.221]:44683 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761259AbYENNcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:32:43 -0400
Message-ID: <482AE934.7060204@openvz.org>
Date: Wed, 14 May 2008 17:29:24 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v4)
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130926.24440.77703.sendpatchset@localhost.localdomain>
In-Reply-To: <20080514130926.24440.77703.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 14 May 2008 17:31:55 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> This patch sets up the rlimit cgroup controller. It adds the basic create,
> destroy and populate functionality. The user interface provided is very
> similar to the memory resource controller. The rlimit controller can be
> enhanced easily in the future to control mlocked pages.
> 
> Changelog v3->v4
> 
> 1. Use PAGE_ALIGN()
> 2. Rename rlimit to memrlimit
> 
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
