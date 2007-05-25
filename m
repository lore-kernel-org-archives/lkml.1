Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXEYG2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXEYG2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXEYG1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:27:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:16756 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbXEYG1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tRdmlre+IlKCQqyx/Ujdo4MOCrWTjUCTNC/a7dIizprrK4E/NHvqZ5tuS1Q6UcaNUXzTNFUtHaq1bg+J03PyJhrcmgCxuuQ0BzGbb0qHL1fzv3ri/7+ijlBGe6BJ3lX8EIcu2w7sS/N+5kfnpF4/MoIzCvEaaaXKXJY42vC28RI=
Message-ID: <a8e1da0705242327q48c5d449p2fc028c40b0bfb08@mail.gmail.com>
Date: Fri, 25 May 2007 06:27:51 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Anton Altaparmakov" <aia21@cantab.net>
In-Reply-To: <20070524224709.0719acfe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	 <Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
	 <a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
	 <20070524224709.0719acfe.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Andrew,

> So I think this was meant:
>
> --- a/fs/ntfs/inode.c~a
> +++ a/fs/ntfs/inode.c
> @@ -140,7 +140,7 @@ static int ntfs_init_locked_inode(struct
>                 if (!ni->name)
>                         return -ENOMEM;
>                 memcpy(ni->name, na->name, i);
> -               ni->name[i] = 0;
> +               ni->name[na->name_len] = 0;
>         }
>         return 0;
>  }
> _
>

I tested it , it doesn't work.
