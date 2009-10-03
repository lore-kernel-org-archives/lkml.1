Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZJCMNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZJCMNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 08:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZJCMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 08:13:31 -0400
Received: from mail-iw0-f188.google.com ([209.85.223.188]:54579 "EHLO
	mail-iw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZJCMNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 08:13:30 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2009 08:13:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dvHzuQM1OOmrEO7yvPFo731txGxve/JR+j/97wlMcyMabWYwCHJ1f2fqneuXlNaflw
         O15iavGEg5e/Zl2focTQ0t27ExsbZGSZUyXTyinRR8lNyNXxuajikZ65LLJMsKI4mLKG
         hepzYzWPPRy4TbkgY++SsP/XyFw1if/xPKjEk=
MIME-Version: 1.0
In-Reply-To: <6599ad830910021501s66cfc108r9a109b84b0f658a4@mail.gmail.com>
References: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
	 <20091002173955.5F72.A69D9226@jp.fujitsu.com>
	 <6599ad830910021501s66cfc108r9a109b84b0f658a4@mail.gmail.com>
Date: Sat, 3 Oct 2009 21:05:44 +0900
X-Google-Sender-Auth: b5dfd124a0ee5f07
Message-ID: <2f11576a0910030505w5a1289ebu78cdc3587caddc82@mail.gmail.com>
Subject: Re: [PATCH 3/3] cgroup: fix strstrip() abuse
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> cgroup_write_X64() and cgroup_write_string() ignore the return
>> value of strstrip().
>> it makes small inconsistent behavior.
>>
>> example:
>> =========================
>>  # cd /mnt/cgroup/hoge
>>  # cat memory.swappiness
>>  60
>>  # echo "59 " > memory.swappiness
>>  # cat memory.swappiness
>>  59
>>  # echo " 58" > memory.swappiness
>>  bash: echo: write error: Invalid argument
>>
>>
>> This patch fixes it.
>>
>> Cc: Li Zefan <lizf@cn.fujitsu.com>
>> Cc: Paul Menage <menage@google.com>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Acked-by: Paul Menage <menage@google.com>
>
> Thanks - although I think I'd s/abuse/misuse/ in the description.

I don't know what's different between them. My dictionary is slightly quiet ;)
Is this X-rated word? if so, I'll resend it soon.
