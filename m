Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYAME72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYAME72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 23:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYAME7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 23:59:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYAME7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 23:59:20 -0500
Date: Sat, 12 Jan 2008 23:59:07 -0500
From: Rik van Riel <riel@redhat.com>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com
Subject: Re: [PATCH 2/2] updating ctime and mtime at syncing
Message-ID: <20080112235907.05fc44d4@bree.surriel.com>
In-Reply-To: <12001992023392-git-send-email-salikhmetov@gmail.com>
References: <12001991991217-git-send-email-salikhmetov@gmail.com>
	<12001992023392-git-send-email-salikhmetov@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 07:39:59 +0300
Anton Salikhmetov <salikhmetov@gmail.com> wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=2645
> 
> Changes for updating the ctime and mtime fields for memory-mapped files:
> 
> 1) new flag triggering update of the inode data;
> 2) new function to update ctime and mtime for block device files;
> 3) new helper function to update ctime and mtime when needed;
> 4) updating time stamps for mapped files in sys_msync() and do_fsync();
> 5) implementing the feature of auto-updating ctime and mtime.
> 
> Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
