Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXCAJSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXCAJSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbXCAJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:18:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:39414 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205AbXCAJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:18:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y3MFIVVYqsZ3GKjVoyPtticO9TBx8TuP+d1JdB8O+IKwmqbd4kmT126eBwcR5C+yeYYyPdvRUmXp0fl91zDjxfaOBXS34BX7DNIJP46lMsDAEQlPEHMnLP2bgKVJgcdZVg/ngiarYhCBWhAL1GioYHSGc/J5pOM1/zX42uqfC5c=
Message-ID: <9a8748490703010117m552221cfs85ddcf5f29de5305@mail.gmail.com>
Date: Thu, 1 Mar 2007 10:17:46 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: nfs@lists.sourceforge.net
Subject: Re: nfs_update_inode: inode 309229856 mode changed, 0100644 to 0040755 - kernel 2.6.13.4
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <9a8748490702260531h45a91113o611c272c0fe7b39f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490702260531h45a91113o611c272c0fe7b39f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> I have a webserver running a rather old 2.6.13.4 kernel that a few
> minutes ago surprised me by logging the following message :
>
>  kernel: nfs_update_inode: inode 309229856 mode changed, 0100644 to 0040755
>
I just got one more of these (well, slightly different, but same basic
issue). This time it was one of my mailservers, also running 2.6.13.4.

  kernel: nfs_update_inode: inode -1073741693 mode changed, 0040700 to 0100644

> The server exporting the filesystem is running 2.6.18.1 (knfsd) -
> nothing is logged on the server...
>
This time it's a different NFS server (still using knfsd), this one is
running kernel 2.6.20. Still nothing logged at the server side.

> So a file changed type and permissions out of the blue.  A few
> questions about that:
>
> Any way I can identify the file (or is it a dir now ;) ?
> Does anyone know if this is a known bug that's been fixed? I couldn't
> find anything via google or git that looked like a fix.
>
These questions still apply :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
