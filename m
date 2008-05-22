Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYEVETj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYEVETj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYEVETb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:19:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbYEVETa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:19:30 -0400
Date: Wed, 21 May 2008 21:18:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
Message-Id: <20080521211833.bc7c5255.akpm@linux-foundation.org>
In-Reply-To: <20080521152948.15001.39361.sendpatchset@localhost.localdomain>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 20:59:48 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)

grumble.  I think I requested a checkpatch warning whenever it comes
across "tmp" or "temp".  Even better would be a gcc coredump.

I'm sure there's something more meaningful we could use here?
