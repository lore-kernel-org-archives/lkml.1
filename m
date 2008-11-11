Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYKKGiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYKKGiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYKKGiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:38:11 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:49788 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYKKGiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:38:11 -0500
Message-ID: <49192842.8000604@knaff.lu>
Date: Tue, 11 Nov 2008 07:37:54 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: lseek(fd, 0, SEEK_CUR) race condition
References: <200811062021.mA6KLCEp030336@hitchhiker.org.lu> <20081110170808.831093ec.akpm@linux-foundation.org>
In-Reply-To: <20081110170808.831093ec.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
[...]
> OK, I think that a concurrent lseek(fd, 0, SEEK_CUR) is a sufficiently
> sane operation that this is worth doing.  As you point out, there is no
> other way of userspace doing what is effectively a read-only operation
> - userspace would be entitled to wonder "ytf did the kernel rewrite the
> file offset for that?".
> 
> 
> Do the below additions look OK?

Yes, these additions look ok to me. Thanks for your quick and easy reply.

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> - fix coding-style
> - fix default_llseek() as well

Wow, that one was missing an unlock_kernel()... I'm wondering why this
hadn't let to some major SNAFU...

> - add comments

Thanks,

Alain
