Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZLNKUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZLNKUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZLNKUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:20:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZLNKUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:20:44 -0500
Subject: Re: [PATCH 2/4] Constify struct kset_uevent_ops for
 2.6.32-git-053fe57ac v2
From: Steven Whitehouse <swhiteho@redhat.com>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, bmarzins@redhat.com,
       torvalds@linux-foundation.org
In-Reply-To: <6710f02ae2e61ac5f9d711c263fa1a5693fff998.1260663000.git.re.emese@gmail.com>
References: <cover.1260663000.git.re.emese@gmail.com>
	 <6710f02ae2e61ac5f9d711c263fa1a5693fff998.1260663000.git.re.emese@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 14 Dec 2009 10:22:44 +0000
Message-Id: <1260786164.2389.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 01:00 +0100, re.emese@gmail.com wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>


Steve.

> ---
>  fs/gfs2/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
> index c5dad1e..2d9b7ed 100644
> --- a/fs/gfs2/sys.c
> +++ b/fs/gfs2/sys.c
> @@ -586,7 +586,7 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
>  	return 0;
>  }
>  
> -static struct kset_uevent_ops gfs2_uevent_ops = {
> +static const struct kset_uevent_ops gfs2_uevent_ops = {
>  	.uevent = gfs2_uevent,
>  };
>  


