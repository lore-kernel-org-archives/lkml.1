Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbXJ0Src@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbXJ0Src (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXJ0SrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:47:21 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:43816 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757669AbXJ0SrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:47:20 -0400
X-YMail-OSG: zOxQK8sVM1kO.Er31GGNLTvKEjQFGfXBLFiVBq3oqmtypyMDKL4wcRGss.rjOoOrF32YxVkehg--
X-RocketYMMF: rancidfat
Date: Sat, 27 Oct 2007 11:47:20 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 0/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
To: Joshua Brindle <method@manicmethod.com>, casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <472343AC.9040502@manicmethod.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <66337.85934.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Joshua Brindle <method@manicmethod.com> wrote:

> Casey Schaufler wrote:
> > The Smack patch and Paul Moore's netlabel API patch,
> > together for 2.6.24-rc1. Paul's changes are identical
> > to the previous posting, but it's been a while so they're
> > here again.
> >
> > The sole intent of change has been to address locking
> > and/or list processing issues. Please don't hesitate to
> > point out any problems that you might see or suggest
> > alternatives where things might not be to your liking.
> >
> > This version is aimed at 2.6.24, and has been tested
> > against 2.6.24-rc1.
> >   
> with both of these patches applied to 2.6.24-rc1 I get the following 
> oops when nfsd starts:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 0000013c
> printing eip: c01d7e39 *pde = 00000000
> Oops: 0000 [#1] SMP
>
> ....

Thanks for the bug report. I have just discovered that it is possible
to have a virtual disk go virtually bad under VMware. I will be
looking at this as soon as I recover.


Casey Schaufler
casey@schaufler-ca.com
