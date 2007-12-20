Return-Path: <linux-kernel-owner+w=401wt.eu-S1765021AbXLTQgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765021AbXLTQgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXLTQf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:35:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43537 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbXLTQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:35:56 -0500
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in
	free_hot_cold_page
From: Dave Hansen <haveblue@us.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <476A972F.6050904@linux.vnet.ibm.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
	 <1198084473.15321.48.camel@localhost>
	 <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
	 <1198158702.6821.8.camel@twins>
	 <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com>
	 <1198160410.6821.13.camel@twins>  <476A972F.6050904@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 08:35:31 -0800
Message-Id: <1198168531.15321.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 21:54 +0530, Balbir Singh wrote:
> 
> I was going to say the same thing, page_get_page_cgroup() does not hold
> any references. May be _get_ in the name is confusing. 

OK, you three had the entire conversation outing me before I even fot to
respond! :)

Yeah, I thought it was a refcount acquisition.  Balbir, it's fine the
way it stands (except for the slightly confusing name).

-- Dave

