Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYHNQL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYHNQL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYHNQLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:11:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54907 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYHNQLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:11:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Thu, 14 Aug 2008 18:14:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
References: <48A36838.3050309@hp.com>
In-Reply-To: <48A36838.3050309@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808141814.43484.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 of August 2008, Alan D. Brunelle wrote:
> I ran into this trying 2.6.27-rc3 today:
> 
> [6.461876] kernel BUG at mm/vmalloc.c:217!
> 
> (full boot log attached)
> 
> I bisected it to:
> 
> git-bisect bad 1c89ac55017f982355c7761e1c912c88c941483d
> 
> which is:
> 
> commit 1c89ac55017f982355c7761e1c912c88c941483d
> Merge: 88fa08f... b1b135c...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Aug 12 08:40:19 2008 -0700
> 
>     Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus

This is a merge commit that introduced several changes into the
kernel.  It would be helpful to search through these changes.

>     *
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus:
>       fix spinlock recursion in hvc_console
>       stop_machine: remove unused variable
>       modules: extend initcall_debug functionality to the module loader
>       export virtio_rng.h
>       lguest: use get_user_pages_fast() instead of get_user_pages()
>       mm: Make generic weak get_user_pages_fast and EXPORT_GPL it
>       lguest: don't set MAC address for guest unless specified
> 
> Backing out to the previous commit boots just fine. I've attached the
> boot.log, config file, lspci.txt and git-bisect-log. If there is
> anything else I can do, I'd be happy to oblige, but I'm checking out
> right now. I'll check in tomorrow morning (Eastern USA).

Thanks,
Rafael
