Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYEJThP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYEJThP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYEJThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:37:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34318 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYEJThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:37:03 -0400
Date: Sat, 10 May 2008 20:37:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 9/9] fs/exec.c: fix a wrong goto path
Message-ID: <20080510193701.GH13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548752866-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12102548752866-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:52:34PM +0800, WANG Cong wrote:
> When nameidata_to_filp() fails, I see no reasons to fall into 'out' path
> where doesn't free any resources at all.

How about "nameidata_to_filp() frees on failure"?
