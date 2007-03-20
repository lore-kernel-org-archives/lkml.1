Return-Path: <linux-kernel-owner+w=401wt.eu-S1750876AbXCTLMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbXCTLMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXCTLMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:12:16 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44017 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXCTLMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:12:15 -0400
Message-ID: <45FFC168.9010807@hitachi.com>
Date: Tue, 20 Mar 2007 20:11:36 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 4/4] coredump: documentation for proc entry
References: <45E7AAFA.4070402@hitachi.com> <45E7AD6B.1090102@hitachi.com> 
    <20070302093543.GB2001@elf.ucw.cz>
In-Reply-To: <20070302093543.GB2001@elf.ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,
I'm sorry for my late reply.

Pavel Machek wrote:

> Hi!
> 
>>+If you don't want to dump all shared memory segments attached to pid 1234,
>>+write 0 to the process's proc file.
>>+
>>+  $ echo 1 > /proc/1234/coredump_omit_anonymous_shared
> 
> Write 0?

Thank you for pointing out. 
It seems I mistook when I changed the documents.
`write 1' is correct.


>>+When a new process is created, the process inherits the flag status from its
>>+parent. It is useful to set the flag before the program runs.
>>+For example:
>>+
>>+  $ echo 1 > /proc/self/coredump_omit_anonymous_shared
>>+  $ ./some_program
>>+
> 
> Notice that this docs is wrong. You have to retry until kernel stops
> producing spurious errors.
> 									Pavel
 
I'll fix the patchset so that kernel doesn't produce the spurious error.

For answers to your another mail, please wait a few days.
I'm still considering the answer partly. 

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory


