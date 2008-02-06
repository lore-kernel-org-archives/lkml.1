Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYBFTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYBFTES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYBFTEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:04:11 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:52467 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYBFTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=VNBzDcGyYHemNndLP489Ev7ksIPHx2PkOidGtOsDNKQou5v1nW0K0nNm+fL8O5JwAxV/YodywPeaCrmrdKUYfoAWKzQXzUhrWBwyvjIFr4m0Sj/WqxVDxAoorHymjmwD5i22aeAWMP2W6e3Wamg6YH4dbYq0SD2sPLMjDNZS9g4=
Date: Wed, 6 Feb 2008 22:03:53 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: OOPS in sysctl.c
Message-ID: <20080206190353.GB1732@martell.zuzino.mipt.ru>
References: <200802050845.58691.hs4233@mail.mn-solutions.de> <200802051224.56413.hs4233@mail.mn-solutions.de> <20080206002420.91124dab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206002420.91124dab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 12:24:20AM -0800, Andrew Morton wrote:
> On Tue, 5 Feb 2008 12:24:56 +0100 Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> 
> > > I have an embedded target (PXA255 based) where I have a nice
> > > running kernel 2.6.15. Today I'm trying to get 2.6.24 running
> > > on it.
> > 
> 
> Backtrace:
> [<c0038bbc>] (sysctl_head_next+0x0/0x64) from [<c00a4b80>] (proc_sys_readdir+0x360/0x394)
>  r4:00000000
> [<c00a4820>] (proc_sys_readdir+0x0/0x394) from [<c007c860>] (vfs_readdir+0x70/0x98)
> [<c007c7f0>] (vfs_readdir+0x0/0x98) from [<c007cdf0>] (sys_getdents64+0x6c/0xc0)
> [<c007cd84>] (sys_getdents64+0x0/0xc0) from [<c0023e60>] (ret_fast_syscall+0x0/0x2c)

Please, post .config and "ls -lR /proc/sys" output _before_ suspend/resume.
