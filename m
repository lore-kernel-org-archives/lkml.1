Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZBKEFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZBKEFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZBKEF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:05:29 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:47745 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZBKEF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bjVd3pxGNZ1lKl1CvXd8J3i1gPsolDhb80vkLkjAgHmuE7sLWslpdH/SMIzzjWaITR
         NTaYfRpXfU7lvARXIWHq8c7I/enBZ0U3K302iLNLX035Y1K1trDB0h6slBXKAOU0FAkm
         7Xq2hcc5FKvXSIyg4RwGK/z4P/b0kpEIM/w0s=
MIME-Version: 1.0
In-Reply-To: <1234324879-12411-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1234324879-12411-1-git-send-email-zohar@linux.vnet.ibm.com>
Date: Tue, 10 Feb 2009 23:05:26 -0500
Message-ID: <8bd0f97a0902102005i70c408afhedf6b1d197e2e308@mail.gmail.com>
Subject: Re: [PATCH] integrity: shmem zero fix
From: Mike Frysinger <vapier.adi@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 23:01, Mimi Zohar wrote:
> Based on comments from Mike Frysinger and Randy Dunlap:
> (http://lkml.org/lkml/2009/2/9/262)
> - moved ima.h include before CONFIG_SHMEM test to fix compiler error
>  on Blackfin:
> mm/shmem.c: In function 'shmem_zero_setup':
> mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
>
> - added 'struct linux_binprm' in ima.h to fix compiler warning on Blackfin:
> In file included from mm/shmem.c:32:
> include/linux/ima.h:25: warning: 'struct linux_binprm' declared inside
> parameter list
> include/linux/ima.h:25: warning: its scope is only this definition or
> declaration, which is probably not what you want
>
> - moved fs.h include within _LINUX_IMA_H definition
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
