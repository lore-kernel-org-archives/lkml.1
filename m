Return-Path: <linux-kernel-owner+w=401wt.eu-S1761873AbYDBWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873AbYDBWT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYDBWTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:19:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56153 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbYDBWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:19:47 -0400
Date: Wed, 2 Apr 2008 18:15:39 -0400
Message-Id: <200804022215.m32MFddK020389@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 02/10] vfs: add path_mkdir() 
In-reply-to: Your message of "Wed, 02 Apr 2008 22:12:49 +0200."
             <20080402201322.317327738@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080402201322.317327738@szeredi.hu>, Miklos Szeredi writes:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Introduce path_mkdir().  Unexport vfs_mkdir() to modules.
> 
> The only internal user of vfs_mkdir() remaining is cgroup_clone().

> +EXPORT_SYMBOL(path_mkdir);

Shouldn't all new exported symbols use EXPORT_SYMBOL_GPL?

Erez.
