Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYJMIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYJMIUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYJMIUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:20:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44142
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbYJMIUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:20:39 -0400
Date: Mon, 13 Oct 2008 01:20:15 -0700 (PDT)
Message-Id: <20081013.012015.107936001.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] /proc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013081908.GA19572@x200.localdomain>
References: <20081013081908.GA19572@x200.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 13 Oct 2008 12:19:08 +0400

> Linus, please, pull from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc

It doesn't merge without conflicts:

davem@sunset:~/src/GIT/linux-2.6$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc
remote: Counting objects: 100, done.        
remote: Compressing objects: 100% (17/17), done.        
remote: Total 71 (delta 60), reused 64 (delta 53)        
Unpacking objects: 100% (71/71), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc
 * branch            proc       -> FETCH_HEAD
Auto-merged Documentation/filesystems/proc.txt
CONFLICT (delete/modify): arch/sparc/include/asm/dma_32.h deleted in HEAD and modified in 3bbfe0596746e1590888a6e1e6a07583265238b7. Version 3bbfe0596746e1590888a6e1e6a07583265238b7 of arch/sparc/include/asm/dma_32.h left in tree.
Auto-merged kernel/sysctl.c
Automatic merge failed; fix conflicts and then commit the result.
davem@sunset:~/src/GIT/linux-2.6$ 

This is caused by my sparc merge that Linux took in mid-day Sunday.
