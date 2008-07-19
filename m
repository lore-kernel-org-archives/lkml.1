Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYGSTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYGSTzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGSTzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 15:55:39 -0400
Received: from namei.org ([69.55.235.186]:54189 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752198AbYGSTzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 15:55:38 -0400
Date: Sun, 20 Jul 2008 05:54:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Al Viro <viro@zeniv.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
Subject: Re: linux-next: Tree for July 17: early crash on x86-64
In-Reply-To: <200807192042.06988.rjw@sisk.pl>
Message-ID: <Xine.LNX.4.64.0807200553380.22632@us.intercode.com.au>
References: <20080718012842.690b8346.sfr@canb.auug.org.au>
 <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com>
 <20080719035231.GU28946@ZenIV.linux.org.uk> <200807192042.06988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008, Rafael J. Wysocki wrote:

> > vfs-next/net-next conflict; apply the patch below on top of the merge.
> 
> That helped, thanks.
> 
> But next it ran into the BUG_ON() in line 883 of security/selinux/avc.c .
> Disabling selinux made the kernel boot, finally.

Ugh, that's not supposed to happen.  Where was this in the boot?  Do you 
have a console log?


- James
-- 
James Morris
<jmorris@namei.org>
