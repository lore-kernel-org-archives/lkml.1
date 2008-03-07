Return-Path: <linux-kernel-owner+w=401wt.eu-S1765499AbYCGJTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765499AbYCGJTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763107AbYCGJJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:09:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763553AbYCGJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:09:12 -0500
Date: Fri, 7 Mar 2008 01:08:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Make memory resource control aware of boot options (v2)
Message-Id: <20080307010819.85b194c9.akpm@linux-foundation.org>
In-Reply-To: <20080307010649.74f51535.akpm@linux-foundation.org>
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
	<20080307085746.25567.71595.sendpatchset@localhost.localdomain>
	<20080307010649.74f51535.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 01:06:49 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 07 Mar 2008 14:27:46 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > +	if (mem_cgroup_subsys.disabled)
> 
> My copy of `struct cgroup_subsys' doesn't have a .disabled?
> 

Ah.  You didn't sequence-number the patches, and they arrived out-of-order. 
tsk.

