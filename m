Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYH2CVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYH2CVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 22:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYH2CVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 22:21:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYH2CVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 22:21:14 -0400
Date: Thu, 28 Aug 2008 19:20:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
 Userspace
Message-Id: <20080828192047.512922b7.akpm@linux-foundation.org>
In-Reply-To: <48B75A4C.60004@kernel.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
	<1219947544-666-6-git-send-email-tj@kernel.org>
	<20080828130740.344f7213.akpm@linux-foundation.org>
	<48B75A4C.60004@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 04:09:16 +0200 Tejun Heo <tj@kernel.org> wrote:

> >> +static int __init cuse_init(void)
> >> +{
> >> +	int rc;
> >> +
> >> +	/* inherit and extend fuse_dev_operations */
> >> +	cuse_channel_fops		= fuse_dev_operations;
> >> +	cuse_channel_fops.owner		= THIS_MODULE;
> >> +	cuse_channel_fops.open		= cuse_channel_open;
> >> +	cuse_channel_fops.release	= cuse_channel_release;
> > 
> > Can't these initialisations be performed at compile-time?
> 
> Only by listing every member.  I can't think of a good way to inherit
> all and then override some in C initialization.  Hmmm.... then again,
> maybe it's better to list every member.

oop, I failed to note the struct assignment there.  The usual rule of
thumb applies: I can be safely ignored.

