Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXETMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXETMYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXETMYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 08:24:11 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:37388 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbXETMYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 08:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ugl8sOBIi/hOc2uWTf+4nsVx6i7XSNnNy9zZ8Ryj8JaL+ZXIbIhl+GM6Ll6VJNklzVRAuwFEAZW2NPi/hTnRxMuGZnWe8d2F2H63pnLEjOg10ZM14u3AVoNBbUHDWhhqpp9+cndVLcPamw6wGR5voeeHC5HibSJJFFgp1f9Immw=
Date: Sun, 20 May 2007 20:23:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: aeb@cwi.nl, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc2 built on ppc (3)
Message-ID: <20070520122351.GC2006@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: aeb@cwi.nl, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Cornelia Huck <cornelia.huck@de.ibm.com>
References: <20070520111113.GE3253@aragorn.home.lxtec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520111113.GE3253@aragorn.home.lxtec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 01:11:13PM +0200, Elimar Riesebieter wrote:
>Hi,
>
>FYI, building the kernel with
>gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
>on my powerbook (PPC) gives:
>
>...
>fs/partitions/check.c: In function 'add_partition':
>fs/partitions/check.c:392: warning: ignoring return value of 'kobject_add', declared with attribute warn_unused_result
>fs/partitions/check.c:395: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>fs/partitions/check.c:403: warning: ignoring return value of 'sysfs_create_file', declared with attribute warn_unused_result
>...
>
>If more info is needed, please contact me via PM, as I am not
>subscribed.
>
>Thanks for your patience
>Elimar
>

I don't know why these warnings are still in kernel. We have fixed them yet. Could you please check and try this patch?

http://marc.info/?l=linux-mm-commits&m=117624330000536&w=2

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>

Regards!

WANG Cong

