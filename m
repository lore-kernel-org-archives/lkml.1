Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZEVAAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZEVAAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZEVAAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:00:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:41610 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZEVAAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:00:08 -0400
Date: Fri, 22 May 2009 09:59:11 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       hooanon05@yahoo.co.jp, "J. Bruce Fields" <bfields@fieldses.org>,
       Eric Paris <eparis@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       David Safford <safford@watson.ibm.com>, linux-nfs@vger.kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/3] integrity: move ima_counts_get
In-Reply-To: <4b26da825c7cff6c22e924012011bedb76f7079b.1242753148.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0905220958570.6348@tundra.namei.org>
References: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com> <4b26da825c7cff6c22e924012011bedb76f7079b.1242753148.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Mimi Zohar wrote:

> Based on discussion on lkml (Andrew Morton and Eric Paris),
> move ima_counts_get down a layer into shmem/hugetlb__file_setup().
> Resolves drm shmem_file_setup() usage case as well.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
