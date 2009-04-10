Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbZDJIOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbZDJIOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZDJIOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:14:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60632 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZDJIOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CAbxgiMT8Uv7olRraQ6o1wErJ8TNK/1pSLu3zY5m2Zmpvf/yGCSuh8D9gLcEtxbToE
         EVb1+wXWDss7w1uNF2hAiXTYDou+lG0/bPoRQD3gwJbDKxaFh5lajkA2c8ruZE8ZzwT7
         59CLDU4eKlx5UTxK9ZwihPgklCm2fXNbF6wWg=
Date: Fri, 10 Apr 2009 10:14:29 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [BISECTED] x11 fbdev on intelfb hangs hard after
	66c1ca019078220dc1bf968f2bb18421100ef147
Message-ID: <20090410081428.GA5595@linux>
Mail-Followup-To: Pavel Roskin <proski@gnu.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <1239314524.7390.14.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239314524.7390.14.camel@mj>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 06:02:04PM -0400, Pavel Roskin wrote:
> Hello!
> 
> I'm running the latest wireless-testing.git kernel, which is 2.6.30-rc1
> plus some wireless bits.  I use intelfb with kernel mode switching and
> X11 using fbdev.  This runs on Fedora 10, fbdev driver is
> xorg-x11-drv-fbdev-0.3.1-7.fc9.x86_64.
> 
> This worked fine with Linux 2.6.29, but after upgrading to 2.6.30-rc1
> X11 hangs hard.
> 
> Bisecting found commit 66c1ca019078220dc1bf968f2bb18421100ef147 to be
> responsible.  It can be reverted on top of 2.6.30-rc1, and the resulting
> kernel is working fine.  The commit is called:
> 
> fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
> 
> I'm especially concerned to see stable@kernel.org in the cc in the log.
> This patch fails on two systems for me, so it's hardly ready for stable
> kernels.
> 
> The kernel config (very minimal, I used it to speed up bisecting),
> xorg.conf and lspci output are attached.

Thanks for reporting Pavel. I agree to revert 66c1ca ASAP.

See also http://lkml.org/lkml/2009/4/9/177.

-Andrea
