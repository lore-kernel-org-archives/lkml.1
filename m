Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZKDBkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZKDBkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZKDBkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:40:05 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52498 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZKDBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:40:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZpG8Vpu39Lh4AosH1Zy7J8k/KZWs7jTUvyQKJVeMD07nAnGCwKzN22UmgtI3bbt3NI
         KycDzxYCoerSAKpphlay3q5ghbF+aDc8OFWQoOjH7jBOPAN7hAycSEpF/baiYPx7P9/b
         qYBwCjm6x2xmGYTNgA2SeP/4u7YnM7YhftxJw=
Message-ID: <4AF0DB84.8050006@gmail.com>
Date: Tue, 03 Nov 2009 17:40:20 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com> <20091104101410.D43E.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091104101410.D43E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Hello,
>> I'm not sure how to handle this,
>> while compiling firefox-3.6b1.source
>> I get this with the default compiling options,
>> as well as custom:
>>
>>
>> [  532.942324] cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
>> [  532.942330] Pid: 16002, comm: cc1plus Tainted: P
>> 2.6.32-rc5-00083-g04ea458 #2
>> [  532.942333] Call Trace:
>> [  532.942342]  [<ffffffff810bce11>] T.417+0x7c/0x245
>> [  532.942347]  [<ffffffff810bd11c>] __out_of_memory+0x142/0x159
>> [  532.942352]  [<ffffffff810bd1a1>] out_of_memory+0x6e/0x9d
>> [  532.942357]  [<ffffffff810c0086>] __alloc_pages_nodemask+0x47e/0x5cc
>> [  532.942363]  [<ffffffff810d2115>] handle_mm_fault+0x25d/0x68e
>> [  532.942369]  [<ffffffff813dfc1d>] do_page_fault+0x2bb/0x2d3
>> [  532.942373]  [<ffffffff813ddb25>] page_fault+0x25/0x30
>> [  532.942376] Mem-Info:
>> [  532.942378] DMA per-cpu:
>> [  532.942380] CPU    0: hi:    0, btch:   1 usd:   0
>> [  532.942383] CPU    1: hi:    0, btch:   1 usd:   0
>> [  532.942385] DMA32 per-cpu:
>> [  532.942388] CPU    0: hi:  186, btch:  31 usd:  94
>> [  532.942391] CPU    1: hi:  186, btch:  31 usd:  23
>> [  532.942393] Normal per-cpu:
>> [  532.942395] CPU    0: hi:  186, btch:  31 usd: 150
>> [  532.942398] CPU    1: hi:  186, btch:  31 usd: 155
>> [  532.942404] active_anon:707575 inactive_anon:264673 isolated_anon:0
>> [  532.942406]  active_file:58 inactive_file:33 isolated_file:0
>>      
>
> file cache (active_file + inactive_file) was very little. It indicate anyone waste too much memory.
> I doubt you use buggy compiler.
>
>
>
>    
hmm... then this is something with firefox then..
In that case I'll continue to build my system with
this compiler.
Although a bit concerned building everything
for the system with a compiler that shows some
memory issue,but if you say its not the compiler,
then I'll carry on with what I'm doing.
(and use an older compiler for firefox).

Justin P. Mattock
