Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYKUJH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYKUJH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYKUJHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:07:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYKUJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:07:08 -0500
Date: Fri, 21 Nov 2008 01:06:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCHSET] fix CGROUP VS RCU
Message-Id: <20081121010637.0f71ffff.akpm@linux-foundation.org>
In-Reply-To: <49267609.8050600@cn.fujitsu.com>
References: <49267609.8050600@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 16:49:13 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> current some cgroup struct are protected by RCU.
> 
> struct protected by RCU:
> 	struct css_set, struct cgroup_subsys_state, struct cgroup
> 
> pointer protected by RCU:
> 	struct task_struct.cgroups, struct css_set.subsys[*],
> 	struct cgroup_subsys_state.cgroup
> the last two pointers are readonly pointer!
> 
> these patches are fix these structs, and pointers. And a faker:
> struct cgroup_subsys.root
> 
> Not cleanup all yet.
> 

These patches aren't sequence numbered.  In what order should they be
applied?

