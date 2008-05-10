Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYEJTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYEJTbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYEJTbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:31:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55738 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYEJTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:31:07 -0400
Date: Sat, 10 May 2008 20:31:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 7/9] fs/exec.c: fix wrong return value of
	prepare_binprm()
Message-ID: <20080510193105.GG13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548553947-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12102548553947-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:52:32PM +0800, WANG Cong wrote:
> All prepare_binprm()'s callers assume that prepare_binprm() fails
> when it returns negative. However, prepare_binprm() most probably returns
> the return value of kernel_read(), which may return positive on failure!
> 
> Thus this should be fixed.

Since when does read return positive on failure?
