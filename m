Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZGVFu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZGVFu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZGVFuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:50:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:58962 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZGVFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YkNYXwQmyimCHGk3YY6ZVWNID3AOTNpAgdAozT9L7/Zg5+yKZ9kvqxw0n8myaWiLIt
         p2gCRsbqMS9hKpMpxtyaOdnNW5X9TP9KM4qzPRvdQiedzBJlFS8+nQ0g97q8WLoWxJsd
         z0M0Z2rv2vtA14fLeuOu+yNyi+8K+sDER/KVY=
Date: Wed, 22 Jul 2009 13:52:32 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] kcore: cleanup and fix bahavior to find physcal
	memory range v2
Message-ID: <20090722055232.GA6281@cr0.nay.redhat.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 02:06:13PM +0900, KAMEZAWA Hiroyuki wrote:
>I'm sorry I can't find who should be in CC.
>

Just keep the original CC's, or run scripts/get_maintainer.pl -f fs/proc/kcore.c.
:-)


>This includes some amounts changes to arch-specici code, 
>but very special codes for kcore. Can I test this in -mm if no objections ?
>
>Now, /proc/kcore 's physical memory information is set up at boot
>via kclist_add(). But it's not updated at memory hotplug etc and
>it can include much memory holes. This patch is for generatinc /proc/kcore
>based on memory management information maintained by the kernel.
>
> For usual archs, /proc/iomem is used
> For ppc, lmb information will be used.
>

This is a good idea!
