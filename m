Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZBKEbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZBKEbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZBKEa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:30:56 -0500
Received: from tundra.namei.org ([65.99.196.166]:2479 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbZBKEa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:30:56 -0500
Date: Wed, 11 Feb 2009 15:30:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: shmem zero fix
In-Reply-To: <8bd0f97a0902102005i70c408afhedf6b1d197e2e308@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0902111530240.10401@tundra.namei.org>
References: <1234324879-12411-1-git-send-email-zohar@linux.vnet.ibm.com> <8bd0f97a0902102005i70c408afhedf6b1d197e2e308@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009, Mike Frysinger wrote:

> On Tue, Feb 10, 2009 at 23:01, Mimi Zohar wrote:
> > Based on comments from Mike Frysinger and Randy Dunlap:
> > (http://lkml.org/lkml/2009/2/9/262)
> > - moved ima.h include before CONFIG_SHMEM test to fix compiler error
> >  on Blackfin:
> > mm/shmem.c: In function 'shmem_zero_setup':
> > mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
> >
> > - added 'struct linux_binprm' in ima.h to fix compiler warning on Blackfin:
> > In file included from mm/shmem.c:32:
> > include/linux/ima.h:25: warning: 'struct linux_binprm' declared inside
> > parameter list
> > include/linux/ima.h:25: warning: its scope is only this definition or
> > declaration, which is probably not what you want
> >
> > - moved fs.h include within _LINUX_IMA_H definition
> >
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
