Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYHDA7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYHDA7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYHDA7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:59:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYHDA7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:59:36 -0400
Message-ID: <4896541B.4020309@cn.fujitsu.com>
Date: Mon, 04 Aug 2008 08:58:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: pj@sgi.com, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removes extra checking kernel/cpuset.c
References: <b9df5fa10808020907g774a88ddj8111a5ffcbe62eb5@mail.gmail.com>
In-Reply-To: <b9df5fa10808020907g774a88ddj8111a5ffcbe62eb5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick wrote:
> Hello guys,  in 'update_domain_attr' function we can just return if
> couldn't update domain attribute , rather then checking dattr and
> again checking relax_domain_level of dattr , if not then return.
> 
> Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)
> 
> --- linux-2.6.26-rc9.orig/kernel/cpuset.c	2008-08-01 08:38:41.000000000 +0600
> +++ linux-2.6.26-rc9/kernel/cpuset.c	2008-08-02 20:37:06.000000000 +0600
> @@ -490,8 +490,6 @@ static int cpusets_overlap(struct cpuset
>  static void
>  update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
>  {
> -	if (!dattr)
> -		return;

The above code no longer exists in latest-git.

>  	if (dattr->relax_domain_level < c->relax_domain_level)
>  		dattr->relax_domain_level = c->relax_domain_level;
>  	return;
> --
