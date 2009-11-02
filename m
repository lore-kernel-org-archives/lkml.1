Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZKBCFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZKBCFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 21:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZKBCFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 21:05:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbZKBCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 21:05:42 -0500
Message-ID: <4AEE3E39.4070403@cn.fujitsu.com>
Date: Mon, 02 Nov 2009 10:04:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] compiler: Introduce __always_unused
References: <4AEE2CEC.8040206@cn.fujitsu.com> <20091101171542.56a44a49@infradead.org>
In-Reply-To: <20091101171542.56a44a49@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 02 Nov 2009 08:50:52 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> Hi,
> 
>> I wrote some code which is used as compile-time checker, and the
>> code should be elided after compile.
>> +#define __always_unused
>> __attribute__((unused)) 
> 
> I have a suggestion.
> In addition to marking it attribute unused, would it be useful to also
> put a section attribute as part of this, to a section that we can then
> drop from the binary by way of the linker script ?
> 

__unused is used to suppress define-but-unused warning. If the
annotated symbol is really unused, it will be optimized out,
so I think we don't need to add a section for this.

