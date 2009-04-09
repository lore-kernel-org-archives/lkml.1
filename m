Return-Path: <linux-kernel-owner+w=401wt.eu-S937379AbZDIXjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937379AbZDIXjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZDIXjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:39:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbZDIXjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:39:04 -0400
Date: Thu, 9 Apr 2009 16:34:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: yur@emcraft.com, yanok@emcraft.com, prodyuth@gmail.com,
       jwboyer@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc: allow 256kB pages with SHMEM
Message-Id: <20090409163403.e82ec1c3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
	<Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 22:01:15 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
> let powerpc 256kB pages coexist with CONFIG_SHMEM again.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Added linuxppc-dev and some other Cc's for this 3/3: sorry
> if you didn't see 1/3 and 2/3, they were just in mm/shmem.c.

Do we think these patches should be in 2.6.30?
