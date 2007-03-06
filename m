Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXCFSxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXCFSxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966014AbXCFSxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:53:21 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:44118 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966004AbXCFSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:53:20 -0500
Date: Tue, 6 Mar 2007 10:53:14 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH] ocfs2: fix module_init error handling
Message-ID: <20070306185314.GA18555@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070304133443.GA8519@APFDCB5C> <20070305195829.GB20528@ca-server1.us.oracle.com> <961aa3350703060838i244469e2g7b10737343398b45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350703060838i244469e2g7b10737343398b45@mail.gmail.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 01:38:17AM +0900, Akinobu Mita wrote:
> OK. There are three problems (these are not likely to happen)
> 
> - There is no error handling when register_filesystem() fails
>  (several slab caches, debugfs directory, and workqueue will not be cleaned)
> 
> - workqueue will not be cleaned if debugfs_create_dir() returns error.
> 
> - kmem_cache_destroy() with NULL oops will happen if
>  ocfs2_free_mem_caches(), exit_ocfs2_uptodate_cache(),
>  or exit_ocfs2_extent_maps() return error.

Ok, both those patches are in ocfs2.git now.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
