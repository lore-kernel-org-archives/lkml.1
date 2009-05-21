Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZEVABd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZEVABd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZEVABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:01:25 -0400
Received: from tundra.namei.org ([65.99.196.166]:41616 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZEVABY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:01:24 -0400
Date: Fri, 22 May 2009 09:58:46 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       hooanon05@yahoo.co.jp, "J. Bruce Fields" <bfields@fieldses.org>,
       Eric Paris <eparis@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       David Safford <safford@watson.ibm.com>, linux-nfs@vger.kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/3] integrity: path_check update
In-Reply-To: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0905220958330.6348@tundra.namei.org>
References: <8971a1efcc5153f1c9b167997e5ca0c3c40a69d5.1242753145.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Mimi Zohar wrote:

> - Add support in ima_path_check() for integrity checking without
> incrementing the counts. (Required for nfsd.)
> - rename and export opencount_get to ima_counts_get
> - replace ima_shm_check calls with ima_counts_get
> - export ima_path_check
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
