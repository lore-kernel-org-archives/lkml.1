Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbXE1ENd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbXE1ENd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXE1EN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:13:26 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:65234 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbXE1EN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fa+Skylv6LgAfQiP4BwsScY/6YPhQrhgS/FB/43Uxsusc8XzW3CE3NHk/4Cm7K/NFlT7vu/r0rRFqRUYeoj5vHkSkZNfOBMYtDCJ/9lhtRXX460h7aQihPdz74FUsS6zJwQDJULChC5X2QoEr4fwSciqj3OVYOYRT+xuYX7WIKU=
Message-ID: <64026d4a0705272113j2ec7f85eqbcfdad814c00f453@mail.gmail.com>
Date: Mon, 28 May 2007 09:43:25 +0530
From: "pradeep singh" <p.singh.rautela@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Altering kernel path execution using module
In-Reply-To: <64026d4a0705272112r23b77c25sd1bb89758abd2632@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64026d4a0705272112r23b77c25sd1bb89758abd2632@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, pradeep singh <p.singh.rautela@gmail.com> wrote:
> Hi All,
>
> Is it possible to change the normal kernel execution path using a
> loadable module, without actually patching the kernel?
> e.g
>     fun1()->fun2()->fun3()->fun4()->fun5()->fun6()
>
> Can i change this method invocation sequence to a custom sequence
> using *only* loadable modules?
>
> i.e
>    fun1()->fun2()-->myfun1()-->myfun2()....->fun4()->fun5()->fun6().
>
> And i do not want to replace any in kernel methods with my custom hooks.
>
> Tried asking on kernelnewbies but i am not satisfied with the
> debuggers pointed as help(i.e kprobes).
>
> Apologies if this is too trivial for you all.
>
> Any help?
Please CC to me as i am not subscribed to the lkml.
thanks
--pradeep
>
> Thanks
> --pradeep
>
