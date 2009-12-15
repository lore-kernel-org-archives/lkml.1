Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbZLOIeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbZLOIeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbZLOIeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:34:09 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:55268 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159AbZLOIeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IFx6R0YU+KJEJaCoyhNkR/qKB6bEtAjr1xG7v7qzRymHqNb6MMRL5JGP2upjljQwrG
         FbNRrVtui8myOt38CyqECLCZN+h28DUJZlxx7STyCFR/f6KWev7H3Bk0WPKQHV9+2vNb
         RcK3UiMs96dQ96pCJHwvD9OjXuQvA8VijVW54=
MIME-Version: 1.0
In-Reply-To: <2375c9f90912142356s6bd6708fi1cb04e6ff0c72c4a@mail.gmail.com>
References: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
	 <2375c9f90912142356s6bd6708fi1cb04e6ff0c72c4a@mail.gmail.com>
Date: Tue, 15 Dec 2009 16:34:01 +0800
Message-ID: <2375c9f90912150034w430dcb07od76273d08ba1b06d@mail.gmail.com>
Subject: Re: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering support
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 3:56 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Dec 15, 2009 at 10:41 AM, Daisuke HATAYAMA
> <d.hatayama@jp.fujitsu.com> wrote:
>> The current ELF dumper implementation can produce broken corefiles
>> if program headers exceed 65535. This number is determined by the
>> number of vmas which the process have. In particular, some extreme
>> programs may use more than 65535 vmas. (If you google max_map_count,
>> you can find some users facing this problem.) This kind of program
>> never be able to generate correct coredumps.
>>
>> This patch implements ``extended numbering'' that uses sh_info
>> field of the first section header instead of e_phnum field in order
>> to represent upto 4294967295 vmas.
>>
>> This is supported by AMD64-ABI(http://www.x86-64.org/documentation.html)
>> and Solaris(http://docs.sun.com/app/docs/doc/817-1984/). Of course,
>> we are preparing patches for gdb and binutils.
>>
>> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
>
>
> Hi,
>
> Can you reorder your patches please?
> Your patch 0/4 depends on 1/4, I am afraid. :-/
>

Oops!

Ignore this, I misread the subject. 4/4 depends on 1/4,
which is fine. :)
