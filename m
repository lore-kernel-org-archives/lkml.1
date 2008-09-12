Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYILQUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYILQUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYILQUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:20:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36869 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbYILQUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:20:24 -0400
Subject: Re: [RFC] [PATCH 8/9] memcg: remove page_cgroup pointer from memmap
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <48CA9500.5060309@linux.vnet.ibm.com>
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
	 <48CA9500.5060309@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 09:19:14 -0700
Message-Id: <1221236354.17910.18.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-12 at 09:12 -0700, Balbir Singh wrote:
> 3. Integrate with sparsemem (last resort for performance), Dave Hansen suggested
> adding a mem_section member and using that.

I also suggested using the sparsemem *structure* without necessarily
using it for pfn_to_page() lookups.  That'll take some rework to
separate out SPARSEMEM_FOR_MEMMAP vs. CONFIG_SPARSE_STRUCTURE_FUN, but
it should be able to be prototyped pretty fast.

-- Dave

