Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYJMIak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYJMIak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbYJMIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:30:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:23216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYJMIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CGRo88jsU9KQvFtEPR7Lz7RI6u16IcQIo/FBjc48XrFF8eOOy2VC2dC+nOu5HREArt
         /784tOHl4vhPpr09vnQKC6XYFgYrLV67DswBl73sLniTQGhHjXZVgOoku2cAw6apt3vd
         jb+O+b4UW1xrz7dxuPWlAJEzHPDIwaCxnYVvM=
Date: Mon, 13 Oct 2008 12:33:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] /proc
Message-ID: <20081013083321.GC19572@x200.localdomain>
References: <20081013081908.GA19572@x200.localdomain> <20081013.012015.107936001.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013.012015.107936001.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 01:20:15AM -0700, David Miller wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Mon, 13 Oct 2008 12:19:08 +0400
> 
> > Linus, please, pull from
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc
> 
> It doesn't merge without conflicts:

So be it. Linus should just rm arch/sparc/include/asm/dma_32.h and commit.

> davem@sunset:~/src/GIT/linux-2.6$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc
> remote: Counting objects: 100, done.        
> remote: Compressing objects: 100% (17/17), done.        
> remote: Total 71 (delta 60), reused 64 (delta 53)        
> Unpacking objects: 100% (71/71), done.
> From git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc
>  * branch            proc       -> FETCH_HEAD
> Auto-merged Documentation/filesystems/proc.txt
> CONFLICT (delete/modify): arch/sparc/include/asm/dma_32.h deleted in HEAD and modified in 3bbfe0596746e1590888a6e1e6a07583265238b7. Version 3bbfe0596746e1590888a6e1e6a07583265238b7 of arch/sparc/include/asm/dma_32.h left in tree.
> Auto-merged kernel/sysctl.c
> Automatic merge failed; fix conflicts and then commit the result.
> davem@sunset:~/src/GIT/linux-2.6$ 
> 
> This is caused by my sparc merge that Linux took in mid-day Sunday.
