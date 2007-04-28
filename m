Return-Path: <linux-kernel-owner+w=401wt.eu-S965847AbXD1Ou3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847AbXD1Ou3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030490AbXD1Ou3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:50:29 -0400
Received: from holomorphy.com ([66.93.40.71]:43107 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbXD1OuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:50:05 -0400
Date: Sat, 28 Apr 2007 07:50:39 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] hugetlbfs: fix error path in module_init
Message-ID: <20070428145039.GX19966@holomorphy.com>
References: <20070428071923.GB9545@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428071923.GB9545@APFDCB5C>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 04:19:23PM +0900, Akinobu Mita wrote:
> init_hugetlbfs_fs() needs to unregister hugetlbfs
> when kern_mount() returns error.
> Cc: William Irwin <wli@holomorphy.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

This patch resolves a clear failure to error check.

Acked-by: William Irwin <bill.irwin@oracle.com>

I'll work out how to do anything with git and point people at a tree
shortly.


-- wli
