Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZIGWVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZIGWVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZIGWVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:21:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:44540 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZIGWVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:21:11 -0400
Date: Tue, 8 Sep 2009 08:20:20 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 5/8] Make 'check_acl()' a first-class filesystem op
In-Reply-To: <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0909080820010.11493@tundra.namei.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Linus Torvalds wrote:

> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 28 Aug 2009 11:51:25 -0700
> 
> This is stage one in flattening out the callchains for the common
> permission testing.  Rather than have most filesystem implemnt their
> inode->i_op->permission own function that just calls back down to the
> VFS layers 'generic_permission()' with the per-filesystem ACL checking
> function, the filesystem can just expose its 'check_acl' function
> directly, and let the VFS layer do everything for it.
> 
> This is all just preparatory - no filesystem actually enables this yet.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
