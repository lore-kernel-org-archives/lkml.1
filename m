Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYBWShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYBWShn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbYBWShf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:37:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbYBWShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:37:34 -0500
Date: Sat, 23 Feb 2008 13:37:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Message-ID: <20080223183731.GA26852@infradead.org>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <20080223085101.GC2262@martell.zuzino.mipt.ru> <20080223.165944.37229792.xiyou.wangcong@gmail.com> <20080223092710.GD2262@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223092710.GD2262@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:27:10PM +0300, Alexey Dobriyan wrote:
> > Use get_personality() can hide the task_struct internals a bit.
> 
> ->personality is going to become something less trivial?
> Sorry, but you sound like C++ people writing tons of pointless get/set
> wrappers. And your get_personality() is worse -- C++ would write it as
> 
> 	current->personality()
> 
> and again, even here, it's immediately visible that current task is
> involved, not some other task.

Yes, completely agreement.  While I might have introduced this gem
back then it is entirely stupid if you think about it.  Please send
patches to kill get_personality and just use current->personality
instead.

Thanks.
