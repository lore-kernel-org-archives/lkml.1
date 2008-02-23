Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYBWTQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYBWTQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYBWTQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:16:39 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbYBWTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:16:38 -0500
Date: Sat, 23 Feb 2008 11:16:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Message-Id: <20080223111629.4d8d2c7b.akpm@linux-foundation.org>
In-Reply-To: <20080223183731.GA26852@infradead.org>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
	<20080223085101.GC2262@martell.zuzino.mipt.ru>
	<20080223.165944.37229792.xiyou.wangcong@gmail.com>
	<20080223092710.GD2262@martell.zuzino.mipt.ru>
	<20080223183731.GA26852@infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 13:37:31 -0500 Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Feb 23, 2008 at 12:27:10PM +0300, Alexey Dobriyan wrote:
> > > Use get_personality() can hide the task_struct internals a bit.
> > 
> > ->personality is going to become something less trivial?
> > Sorry, but you sound like C++ people writing tons of pointless get/set
> > wrappers. And your get_personality() is worse -- C++ would write it as
> > 
> > 	current->personality()
> > 
> > and again, even here, it's immediately visible that current task is
> > involved, not some other task.
> 
> Yes, completely agreement.  While I might have introduced this gem
> back then it is entirely stupid if you think about it.  Please send
> patches to kill get_personality and just use current->personality
> instead.
> 

yup.

We'll generally only add wrappers of this form if we need to provide
alternative implementations, or if we expect that we shall do so in the
future.

