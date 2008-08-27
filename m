Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYH0ChS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYH0ChS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYH0ChD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:37:03 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:39511 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYH0ChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pzKVLakmCfGex9iuciZ/O9JOe/VcpKxw+tNAvDBRbH60T2s8x4diA26EFYX5SFC+Y8
         gYykCLNemhlyOf741hD7tKwVCVxa2MYlulwsAoqOS7yTY+sOyc2esKCjoThRr2gAqlll
         x1h+ufRxm0iTTBinPzfD8GM8b2Y22RlSYE3So=
Message-ID: <f7848160808261936m18c69dc0r26f41850efae4b91@mail.gmail.com>
Date: Tue, 26 Aug 2008 22:36:59 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808261837530.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
	 <alpine.LFD.1.10.0808261837530.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 9:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 26 Aug 2008, Parag Warudkar wrote:
>>
>> And although you said in your later reply that Linux x86 with 4K
>> stacks should be more than usable - my experiences running a untainted
>> desktop/file server with 4K stack have been always disastrous XFS or
>> not.  It _might_ work for some well defined workloads but you would
>> not want to risk 4K stacks otherwise.
>
> Umm. How long?
>

IIRC the last I tried 4K stacks with x86 was on 2.6.21 - Fedora 7
kernel, around June 07 time frame.
The oops included a ugly and long call trace that I still remember.

> And a lot of the cases of us
> having structures on the stack is actually not worth it, and tends to be
> about being lazy rather than anything else.

What about deep call chains? The problem with the uptake of 4K stacks
seems to be that is not reliably provable that it will work under all
circumstances.

Parag
