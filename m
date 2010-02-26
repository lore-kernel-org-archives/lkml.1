Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935494Ab0BZH4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:56:42 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41374 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935455Ab0BZH4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:56:41 -0500
Date: Fri, 26 Feb 2010 08:56:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cfq: Remove useless css reference get
Message-ID: <20100226075639.GG1025@kernel.dk>
References: <4B289C93.3070603@cn.fujitsu.com> <20091221162850.GB10994@redhat.com> <4B875A73.2070103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B875A73.2070103@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26 2010, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Wed, Dec 16, 2009 at 04:38:43PM +0800, Gui Jianfeng wrote:
> >> There's no need to take css reference here, for the caller
> >> has already called rcu_read_lock() to prevent cgroup from 
> >> being removed.
> >>
> >> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Hi Jens
> 
> Would you pick this patch up?

Yep, it's added.

-- 
Jens Axboe

