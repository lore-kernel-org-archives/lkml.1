Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbYEJTZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYEJTZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbYEJTZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:25:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52116 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYEJTZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:25:28 -0400
Date: Sat, 10 May 2008 20:25:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 6/9] fs/binfmt_misc.c: fix resource leaks
Message-ID: <20080510192527.GF13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548463329-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12102548463329-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:52:31PM +0800, WANG Cong wrote:
>  ->load_binary()'s caller only frees resources which ->load_binary() applied
> when it succeeded, so ->load_binary() itself should free the resources on
> failure.

Same problem.
