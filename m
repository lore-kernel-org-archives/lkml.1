Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXCTOkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXCTOkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXCTOkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:40:22 -0400
Received: from rubis.org ([82.230.33.161]:54898 "EHLO rubis.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXCTOkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:40:21 -0400
Message-ID: <45FFF241.7060203@rubis.org>
Date: Tue, 20 Mar 2007 15:40:01 +0100
From: =?ISO-8859-15?Q?St=E9phane_Jourdois?= <kwisatz@rubis.org>
User-Agent: IceDove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- init/.missing_syscalls.h.cmd:2:
 *** missing separator. Stop.
References: <a44ae5cd0703200652q12aa9398if908757174ba1a6@mail.gmail.com>	 <45FFECFB.3040003@rubis.org> <a44ae5cd0703200729t1b9c3d29x59d4f85230d40464@mail.gmail.com>
In-Reply-To: <a44ae5cd0703200729t1b9c3d29x59d4f85230d40464@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane a écrit :
> On 3/20/07, Stéphane Jourdois <kwisatz@rubis.org> wrote:
>> Miles Lane a écrit :
>> > Hello,
>> >
>> > I don't see any announcement for 2.6.21-rc4-mm1 on LKML, but I went
>> > ahead and tried it out.  I hit the following, even after running
>> > mrproper.
>> >
>> > init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
>> > make: *** [.tmp_vmlinux1] Error 2
>>
>> Would you please try the following patch ?
>>
>> http://lkml.org/lkml/2007/3/20/79
> 
> I tried your patch.  After applying it, the error still occurred, so
> then I performed the other stepa you mentioned:
>         rm init/missing_syscalls.h

Of course, you have to first delete the corrupted file with this command:
	rm init/.missing_syscalls.h.cmd
The command :
	rm init/missing_syscalls.h
works only once, and you have to redo it at each compile.

>         make init

This one is not necessary.

> I was then able to continue the build successfully.
> 
> Hopefully, I'd not need to run the additional steps again.  Otherwise,
> the patch needs a little more work.

unlink the good file (init/.missing_syscalls.h.cmd), not the .h file,
and you won't need to redo it again :-)

I admit I should have said that earlier ;-)


The fact that whole init/ is not compiled again when init/Makefile is
perhaps a bug, but it is unrelated to this bug/patch.

Thanks.

-- 
 ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
 \\\   24 rue Cauchy         X                         ///
  \\\  75015  Paris         / \    +33 6 8643 3085    ///
