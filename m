Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXGJXbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXGJXbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbXGJXaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:30:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759736AbXGJXa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:30:28 -0400
Date: Tue, 10 Jul 2007 16:30:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
Message-Id: <20070710163015.ab40ed2a.akpm@linux-foundation.org>
In-Reply-To: <1183275361.4010.119.camel@localhost.localdomain>
References: <1183275361.4010.119.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:36:01 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> Turn on extents feature by default in ext4 filesystem. User could use
> -o noextents to turn it off.
> 

Oh, there you go.

> 
> Index: linux-2.6.22-rc4/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:03:09.000000000 -0700
> @@ -1546,6 +1546,12 @@
>  
>  	set_opt(sbi->s_mount_opt, RESERVATION);
>  
> +	/*
> +	 * turn on extents feature by default in ext4 filesystem
> +	 * User -o noextents to turn it off
> +	 */
> +	set_opt (sbi->s_mount_opt, EXTENTS);
> +

Broken coding style.

Please feed all the ext4 patches through scripts/checkpatch.pl (preferably
version 0.07 - see Andy's patch on lkml) and then consider addressing the
(quite large) number of mistakes which are detected.


