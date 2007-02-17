Return-Path: <linux-kernel-owner+w=401wt.eu-S1946337AbXBQAPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946337AbXBQAPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946338AbXBQAPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:15:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946337AbXBQAPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:15:34 -0500
Date: Fri, 16 Feb 2007 16:15:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: olof@lixom.net (Olof Johansson)
Cc: trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
Message-Id: <20070216161519.52db76c4.akpm@linux-foundation.org>
In-Reply-To: <20070216170532.GA4895@lixom.net>
References: <20070216170532.GA4895@lixom.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 11:05:32 -0600
olof@lixom.net (Olof Johansson) wrote:

> +	nfsi->req_lock = SPIN_LOCK_UNLOCKED;

This can confound lockdep.  Please use spin_lock_init().
