Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYKZLeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYKZLeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYKZLeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:34:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51681 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYKZLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:34:21 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, greg@kroah.com
In-reply-to: <492D2224.7000302@kernel.org> (message from Tejun Heo on Wed, 26
	Nov 2008 19:17:08 +0900)
Subject: Re: [PATCH 5/5 UPDATED] CUSE: implement CUSE - Character device in
 Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org>	<1227190983-5820-6-git-send-email-tj@kernel.org> <20081121211607.49e0ec84.akpm@linux-foundation.org> <4927BC9A.3000001@kernel.org> <4927BDC7.8020905@kernel.org> <E1L5HDg-0001Ty-1u@pomaz-ex.szeredi.hu> <492D2224.7000302@kernel.org>
Message-Id: <E1L5Ieo-0001iE-0P@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Nov 2008 12:34:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Tejun Heo wrote:
> Hello,
> 
> Miklos Szeredi wrote:
> > Hi Tejun,
> > 
> > Apologies for the late review.
> 
> :-)

I meant late compared to three months ago, when you first posted the
CUSE patches :)

> Yes, I agree.  I was mostly being lazy.  I'll try to rip off mnt
> assumption from FUSE and make CUSE bypass the mnt thing.
> 
> >> +	worker = kthread_run(cuse_init_worker, cuse_conn_get(cc),
> >> +			     "cuse-init-pid%d", current->pid);
> > 
> > This could be done without a kthread, by setting the ->end() callback
> > for the INIT request, no?
> 
> Indeed.  Will switch to ->end().

Cool, thanks.

Miklos
