Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYJWWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYJWWyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYJWWyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:54:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:43300 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYJWWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JvFUmzyAfe/RDDpn7ON7TGTpP0tNB1VHEy7oYVGVXyT0tkSp5rAAaWdyfyFm6uS6Ue
         slQ6iUDQVIwgmJx3zRoymjVJVf2tff76bODhbeIIh/VXdwVAKKFP2TxOeP6dGZcoSkRq
         pmgOap0rISnzRHYC9p5AI3PuKgXYw7eB9UhNk=
Message-ID: <f7848160810231554ra4dd0d4i2d81c817e04c8cbc@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:54:32 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Tomasz Chmielewski" <mangoo@wpkg.org>
Subject: Re: Stale NFS File Handle but !NFS
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4900FA92.4000409@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4900FA92.4000409@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 6:28 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> Anyone got an idea why I am getting the below error with today's git
>> while compiling the kernel?
>>
>>  LD      arch/x86/vdso/built-in.o
>> scripts/Makefile.build:373: net/netfilter/.xt_mac.o.cmd: Stale NFS file
>> handle
>> make[2]: stat: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
>> make[2]: *** No rule to make target `net/netfilter/.xt_mac.o.cmd'.  Stop.
>> make[1]: *** [net/netfilter] Error 2
>> make: *** [net] Error 2
>> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ rm
>> net/netfilter/.xt_mac.o.cmd
>> rm: cannot remove `net/netfilter/.xt_mac.o.cmd': Stale NFS file handle
>> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ sudo rm
>> net/netfilter/.xt_mac.o.cmd
>>
>> Even trying 'sudo rm -f' on that file gives the same error.
>>
>> I am not using NFS at all which makes this one sound weird!
>
> Broken filesystem?
>
> You may try fscking the filesystem.
>

Yep - just finished that and got unused/deleted inode errors plus bunch more.

That's weird though since this is a new machine and new install - time
to do a memtest followed by going back to stable kernel.

Thanks
Parag
