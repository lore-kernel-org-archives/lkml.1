Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbZE0Xtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbZE0Xtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbZE0Xtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:49:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:57373 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761227AbZE0Xta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:49:30 -0400
Date: Thu, 28 May 2009 09:49:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       hooanon05@yahoo.co.jp, "J. Bruce Fields" <bfields@fieldses.org>,
       Hugh Dickins <hugh@veritas.com>, David Safford <safford@watson.ibm.com>,
       linux-nfs@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v2] integrity: nfsd imbalance bug fix
In-Reply-To: <1243431112-7388-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0905280948500.28804@tundra.namei.org>
References: <1243431112-7388-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Mimi Zohar wrote:

> 
> This patch adds:
> - integrity (permission) checking for nfsd exported files in nfsd_permission().
> - a call to increment counts for files opened by nfsd.
> 
> This patch has been updated to return the nfs error types.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
