Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888Ab0A2GT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0A2GT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934Ab0A2GT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:19:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:38889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab0A2GT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:19:57 -0500
Date: Fri, 29 Jan 2010 17:19:48 +1100
From: Neil Brown <neilb@suse.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH] drivers/md: remove unnecessary casts of void *
Message-ID: <20100129171948.7b4a4bcd@notabene>
In-Reply-To: <201001081542.35552.hartleys@visionengravers.com>
References: <201001081542.35552.hartleys@visionengravers.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 15:42:35 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> drivers/md: Remove unnecessary casts of void *
> 
> void pointers do not need to be cast to other pointer types.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Neil Brown <neilb@suse.de>
> 

Thanks. 
I have taken the non-dm parts of this into my (md) tree.
I'll leave the dm bits for the dm developers.

NeilBrown


> ---
> 
>  drivers/md/bitmap.c         |    8 ++++----
>  drivers/md/dm-crypt.c       |    4 ++--
>  drivers/md/dm-io.c          |    8 ++++----
>  drivers/md/dm-kcopyd.c      |    4 ++--
>  drivers/md/dm-linear.c      |    6 +++---
>  drivers/md/dm-log.c         |   24 ++++++++++++------------
>  drivers/md/dm-mpath.c       |   12 ++++++------
>  drivers/md/dm-raid1.c       |   10 +++++-----
>  drivers/md/dm-round-robin.c |   10 +++++-----
>  drivers/md/dm-stripe.c      |    6 +++---
>  drivers/md/dm.c             |    2 +-
>  drivers/md/faulty.c         |    6 +++---
>  drivers/md/multipath.c      |    2 +-
>  drivers/md/raid1.c          |    8 ++++----
>  drivers/md/raid10.c         |   10 +++++-----
>  drivers/md/raid5.c          |   10 +++++-----
>  16 files changed, 65 insertions(+), 65 deletions(-)
