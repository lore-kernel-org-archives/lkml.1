Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZGJDQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZGJDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZGJDQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:16:50 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:36836 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZGJDQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZIKp7uQJR1D42not7TmS7Lk3YscSTzYdmZtGgcxb/Jsa+dLp8P8Jw9/FCHvbUSIN2g
         rAfcn2VU1TVS/kTG9TLvZnP6wJFDtaW8W89VL3RjyRX4Epf/9OBvjANxP4pMtIcVOQNv
         11EpfUNXt1oKDD9PL5hjkHKAiAQ5nYD86LWR0=
Date: Fri, 10 Jul 2009 11:18:54 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: fd leak if pipe() is called with an invalid address.
Message-ID: <20090710031854.GC5694@cr0.nay.redhat.com>
References: <4A4C6013.9090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C6013.9090509@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 03:21:55PM +0800, Changli Gao wrote:
>fd leak if pipe() is called with an invalid address.
>
>Though -EFAULT is returned, the file descriptors opened by pipe() call
>are left open.
>
>Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>----
>
> x86/ia32/sys_ia32.c     |    5 ++++-
> xtensa/kernel/syscall.c |    5 ++++-
> 2 files changed, 8 insertions(+), 2 deletions(-)
>
>
>--- arch/x86/ia32/sys_ia32.c.orig	2009-07-02 15:08:39.000000000 +0800
>+++ arch/x86/ia32/sys_ia32.c	2009-07-02 15:09:49.000000000 +0800

This patch is not correctly made... You need to make the patch in the
_upper_ directory of the top source code tree (if you don't use git),
so that we can apply it with 'patch -p1 < XXX'.

Probably this is the reason why Linus still doesn't merge it.

Can you re-make it and resend with my Acked-by?

Thanks.
