Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYFYXlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYFYXlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYFYXlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:41:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYFYXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:41:35 -0400
Date: Wed, 25 Jun 2008 16:41:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [2/2] memrlimit fix usage of tmp as a parameter name
Message-Id: <20080625164121.9146fb56.akpm@linux-foundation.org>
In-Reply-To: <20080620150152.16094.76790.sendpatchset@localhost.localdomain>
References: <20080620150132.16094.29151.sendpatchset@localhost.localdomain>
	<20080620150152.16094.76790.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 20:31:52 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Fix the variable tmp being used in write_strategy. This patch replaces tmp
> with val, the fact that it is an output parameter can be interpreted from
> the pass by reference.

Paul's "CGroup Files: Convert res_counter_write() to be a cgroups
write_string() handler"
(memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch)
deleted memrlimit_cgroup_write_strategy(), so problem solved ;)


