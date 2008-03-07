Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbYCGJSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbYCGJSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763336AbYCGJI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:08:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759909AbYCGJIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:08:23 -0500
Date: Fri, 7 Mar 2008 01:06:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Make memory resource control aware of boot options (v2)
Message-Id: <20080307010649.74f51535.akpm@linux-foundation.org>
In-Reply-To: <20080307085746.25567.71595.sendpatchset@localhost.localdomain>
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
	<20080307085746.25567.71595.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Mar 2008 14:27:46 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +	if (mem_cgroup_subsys.disabled)

My copy of `struct cgroup_subsys' doesn't have a .disabled?

If it did, I might want it __read_mostly.
