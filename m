Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbXL3FHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbXL3FHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 00:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXL3FHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 00:07:30 -0500
Received: from namei.org ([69.55.235.186]:50071 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbXL3FH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 00:07:29 -0500
Date: Sun, 30 Dec 2007 16:07:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: remove security_sb_post_mountroot hook
In-Reply-To: <200712300020.lBU0KPcr010209@tazenda.hos.anvin.org>
Message-ID: <Xine.LNX.4.64.0712301606001.19117@us.intercode.com.au>
References: <200712300020.lBU0KPcr010209@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, H. Peter Anvin wrote:

> The security_sb_post_mountroot() hook is long-since obsolete, and is
> fundamentally broken: it is never invoked if someone uses initramfs.
> This is particularly damaging, because the existence of this hook has
> been used as motivation for not using initramfs.
> 
> Stephen Smalley confirmed on 2007-07-19 that this hook was originally
> used by SELinux but can now be safely removed:
> 
>      http://marc.info/?l=linux-kernel&m=118485683612916&w=2

Thanks.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


-- 
James Morris
<jmorris@namei.org>
