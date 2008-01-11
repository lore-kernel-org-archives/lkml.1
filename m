Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbYAKQDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbYAKQDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbYAKQDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:03:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759053AbYAKQDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:03:31 -0500
Date: Fri, 11 Jan 2008 11:03:16 -0500
From: Rik van Riel <riel@redhat.com>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: "dmitri.vorobiev" <dmitri.vorobiev@auriga.ru>, jakob@unthought.net,
       linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at
 syncing
Message-ID: <20080111110316.6a83ed54@bree.surriel.com>
In-Reply-To: <1200011929.19293.93.camel@codedot>
References: <1200006638.19293.42.camel@codedot>
	<1200011929.19293.93.camel@codedot>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 03:38:49 +0300
Anton Salikhmetov <salikhmetov@gmail.com> wrote:

> From: Anton Salikhmetov <salikhmetov@gmail.com>
> 
> The patch contains changes for updating the ctime and mtime fields for memory mapped files:
> 
> 1) adding a new flag triggering update of the inode data;
> 2) implementing a helper function for checking that flag and updating ctime and mtime;
> 3) updating time stamps for mapped files in sys_msync() and do_fsync().
> 
> Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
