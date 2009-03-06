Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZCFH36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZCFH36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZCFH3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:29:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:44332 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750728AbZCFH3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:29:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6d/c15zu6mwChvcYDH//m9YIxZ5zxq/cm+2J8S8
	5tfnxbwTOKA6gs
Subject: Re: [GIT PULL] x86, percpu: implement and use reserved percpu alloc
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jaswinder@kernel.org,
       cooloney@kernel.org
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 08:29:42 +0100
Message-Id: <1236324582.5968.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 15:46 +0900, Tejun Heo wrote:
> Hello,
> 
> Please pull from the following git vector.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> This patchset implements reserved percpu alloc from the first chunk
> and uses it for static perpcu variables in modules on x86_64.  This is
> necessary because x86_64 expects symbols to be relocatable using 32bit
> relocations but dynamic percpu allocation does not guarantee it
> leading to relocation overflow during module load.

Tested, my module loading woes are cured.

	-Mike

