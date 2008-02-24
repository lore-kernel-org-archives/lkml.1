Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbYBXEI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbYBXEI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYBXEIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:08:48 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:63791 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYBXEIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=OSbDA88wshw1HlN+tDTz0c47rAQ1dg7zML4IJlZQaBrS+B16v0iySZO7214UoWEuu/xgsQbh6tFcOSID+UQTSYB2mkNA2ONL0bbN+8t9T+fSprnkdWVsgK/nIEDB9BSaOibqoq8u56SNEYmOfyStfLcFqePlqzfs7ymGvJQgAYY=
Date: Sun, 24 Feb 2008 12:03:37 +0800 (CST)
Message-Id: <20080224.120337.42455896.xiyou.wangcong@gmail.com>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080223111629.4d8d2c7b.akpm@linux-foundation.org>
References: <20080223092710.GD2262@martell.zuzino.mipt.ru>
	<20080223183731.GA26852@infradead.org>
	<20080223111629.4d8d2c7b.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Date: Sat, 23 Feb 2008 11:16:29 -0800
Message-ID: <20080223111629.4d8d2c7b.akpm@linux-foundation.org>

> On Sat, 23 Feb 2008 13:37:31 -0500 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Sat, Feb 23, 2008 at 12:27:10PM +0300, Alexey Dobriyan wrote:
> > > > Use get_personality() can hide the task_struct internals a bit.
> > > 
> > > ->personality is going to become something less trivial?
> > > Sorry, but you sound like C++ people writing tons of pointless get/set
> > > wrappers. And your get_personality() is worse -- C++ would write it as
> > > 
> > > 	current->personality()
> > > 
> > > and again, even here, it's immediately visible that current task is
> > > involved, not some other task.
> > 
> > Yes, completely agreement.  While I might have introduced this gem
> > back then it is entirely stupid if you think about it.  Please send
> > patches to kill get_personality and just use current->personality
> > instead.
> > 
> 
> yup.
> 
> We'll generally only add wrappers of this form if we need to provide
> alternative implementations, or if we expect that we shall do so in the
> future.
> 

Ok. I will send a patch to remove it.
