Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0CIO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:26:53 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:49401 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0CIO0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pmFDaGP1dTT1u2/INzqkCL4RnC3TdwDJgtoBvcRFz4Yc0LADsLXRrV/XNHR0ZuPMZ4
         aDeV/nS5nmk4psrCD+42JiWU+GOmvPB7dldTXxCDvOU2S4SuKPGwr70bCzjfvng7ACp2
         p7m/Sqx85Ilh6X2O8L0B9BnlBiC37755QIfSk=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1003020115m4016c5f6v643e90a6c6415e74@mail.gmail.com>
References: <20100301120321.8851ba86.sfr@canb.auug.org.au> 
	<8bd0f97a1003020115m4016c5f6v643e90a6c6415e74@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 09:26:29 -0500
Message-ID: <8bd0f97a1003090626r207042e2lb7d4954e8d38ee3f@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the blackfin tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 04:15, Mike Frysinger wrote:
> On Sun, Feb 28, 2010 at 20:03, Stephen Rothwell wrote:
>> After merging the blackfin tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>>
>> kernel/trace/trace_syscalls.c:402: error: redefinition of 'arch_syscall_addr'
>> kernel/trace/trace_syscalls.c:397: note: previous definition of 'arch_syscall_addr' was here
>>
>> Caused by commit d156d1881ea54ec609d92388601661c2679439bb ("ftrace: unify
>> arch_syscall_addr() implementations") from the blackfin tree interacting
>> with commit e7b8e675d9c71b868b66f62f725a948047514719 ("tracing: Unify
>> arch_syscall_addr() implementations") from Linus' tree.
>>
>> These are slightly different versions of the same patch. but merging with the blackfin tree managed to add a second copy of the above function.  I have applied the following patch for today.
>
> i'm traveling atm and wont be able to clean up my tree for a few more
> days.  i'd suggest you just drop the Blackfin tree as well as your
> local patch.  i'll drop a line once things are sane again on my side.

my tree is sane again, so if you could pick it up again, that'd be
great.  thanks!
-mike
