Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZGAD3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZGAD3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZGAD3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:29:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:4630 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZGAD3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aRt3ruDMJNh2/OhAZPI7IE6jvE5LZy38s+7hfDGf3TZzXlAH2oGpqITUlr83b4HQ4x
         7m+aIaaZiPvF06cZ0LRnzZH5jzZ0fp9fNXfYYCPEEXX7Pw4ET27qBFuzMyyzaF8LaFMj
         IeUcXWrI0qk+I9Tphpr0KUoS0vSvwVIvc5opg=
MIME-Version: 1.0
In-Reply-To: <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
	 <20090701005437.GA5856@cr0.nay.redhat.com>
	 <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
Date: Wed, 1 Jul 2009 11:29:14 +0800
Message-ID: <daef60380906302029r1f2ad54dk30dd3d75ad53624@mail.gmail.com>
Subject: Re: [PATCH] Fix the multithread program core thread message error
From: Hui Zhu <teawater@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 11:27, Hui Zhu<teawater@gmail.com> wrote:
> Hi Amerigo,
>
> Thanks for your reply.
>
> On Wed, Jul 1, 2009 at 08:54, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>
>> Hi, Hui.
>>
>> On Tue, Jun 30, 2009 at 05:12:31PM +0800, Hui Zhu wrote:
>>>Fix the multithread program core thread message error.
>>>The thread message of core file is generated in
>>>elf_dump_thread_status.  The register values is set by
>>>elf_core_copy_task_regs in this function.
>>>static inline int elf_core_copy_task_regs(struct task_struct *t,
>>>                                          elf_gregset_t* elfregs)
>>>{
>>>
>>>       return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>>>       return 0;
>>>}
>>>If a arch doesn't define ELF_CORE_COPY_TASK_REGS, This function will do
>>>nothing.  Then the core file will not have the register message of
>>>thread.
>>>So add elf_core_copy_regs to set regiser values if
>>>ELF_CORE_COPY_TASK_REGS doesn't define.
>>
>>
>> You forgot your Signed-off-by line. :)
>
> Signed-off-by: Hui Zhu <hui.zhu@windriver.com>

I need change it to Signed-off-by: Hui Zhu <teawater@gmail.com>
Sorry about it.

Thanks,
Hui
