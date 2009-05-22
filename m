Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZEVJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZEVJEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZEVJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:04:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:59436 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZEVJEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:04:23 -0400
Date: Fri, 22 May 2009 19:04:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the security-testing tree with Linus'
 tree
In-Reply-To: <20090522053542.GY8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.2.00.0905221903020.12996@tundra.namei.org>
References: <20090522152901.2d220889.sfr@canb.auug.org.au> <20090522053542.GY8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Al Viro wrote:

> On Fri, May 22, 2009 at 03:29:01PM +1000, Stephen Rothwell wrote:
> > Hi James,
> > 
> > Today's linux-next merge of the security-testing tree got a conflict in
> > fs/exec.c between commits a44ddbb6d8a8ffe4e34e417048dfdd8f3dd1de4f ("Make
> > open_exec() and sys_uselib() use may_open(), instead of duplicating its
> > parts") and 6e8341a11eb21826b7192d0bb88cb5b44900a9af ("Switch open_exec()
> > and sys_uselib() to do_open_filp()") from Linus' tree and commit
> > b9fc745db833bbf74b4988493b8cd902a84c9415 ("integrity: path_check update")
> > from the security-testing tree.
> > 
> > I used the version of these conflicts from Linus' tree as I assume that
> > the changes to may_open() from the latter patch are sufficient.  Please
> > check and let me know (or merge Linus' tree and do the resolution for
> > yourself :-)).
> 
> Just drop their changes to sys_uselib() and open_exec() and keep the
> rest of their patch.

I've merged Linus' tree into mine and done the above, see fs/exec.c in 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

(I don't know how to get the conflict resolution diff out of git).


- James
-- 
James Morris
<jmorris@namei.org>
