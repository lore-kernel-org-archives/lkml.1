Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbYG3Kh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbYG3Kh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYG3Kht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:37:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYG3Khs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:37:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=aq1VLNBxK99FkJkknz2koazgGYnMI7lVaZUEYmMR8sHFC0rapeSpoHGLgiEQNz+0y
	YEaiXp9T6Zhk3omNqR66g==
Message-ID: <6599ad830807300337h1226387cq2c8467e164253250@mail.gmail.com>
Date: Wed, 30 Jul 2008 03:37:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: uninline cgroup_has_css_refs()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <488D2D0F.7030002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488D2D0F.7030002@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 7:21 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> It's not small enough, and has 2 call sites.
>
>  text    data     bss     dec     hex filename
> 12813    1676    4832   19321    4b79 cgroup.o.orig
> 12775    1676    4832   19283    4b53 cgroup.o
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I'm not sure that saving 38 bytes is worth the tiny slowdown this
might introduce, but I guess it doesn't hurt much either way.

Paul
