Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab0CBJPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:15:44 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33328 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0CBJPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TBImiauidACpmRQp7hODOAvhJ17kx2xwHnnekeMP+6RyrUX5YOOpTqp2iPxUwLizpB
         UOBaRXrxUzrlYL4y9FonKR18UnccQE97JiQaS41tPvoya3QjUazB0/HFv1BYNHc8khcy
         ceqvsuezeIXGNfGiLpL7eK+8+ZBVG/4cjzU1U=
MIME-Version: 1.0
In-Reply-To: <20100301120321.8851ba86.sfr@canb.auug.org.au>
References: <20100301120321.8851ba86.sfr@canb.auug.org.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 2 Mar 2010 04:15:19 -0500
Message-ID: <8bd0f97a1003020115m4016c5f6v643e90a6c6415e74@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the blackfin tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 20:03, Stephen Rothwell wrote:
> After merging the blackfin tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> kernel/trace/trace_syscalls.c:402: error: redefinition of 'arch_syscall_addr'
> kernel/trace/trace_syscalls.c:397: note: previous definition of 'arch_syscall_addr' was here
>
> Caused by commit d156d1881ea54ec609d92388601661c2679439bb ("ftrace: unify
> arch_syscall_addr() implementations") from the blackfin tree interacting
> with commit e7b8e675d9c71b868b66f62f725a948047514719 ("tracing: Unify
> arch_syscall_addr() implementations") from Linus' tree.
>
> These are slightly different versions of the same patch. but merging with the blackfin tree managed to add a second copy of the above function.  I have applied the following patch for today.

i'm traveling atm and wont be able to clean up my tree for a few more
days.  i'd suggest you just drop the Blackfin tree as well as your
local patch.  i'll drop a line once things are sane again on my side.
-mike
