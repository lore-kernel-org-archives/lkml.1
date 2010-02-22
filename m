Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0BVXTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:19:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0BVXTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:19:21 -0500
Message-ID: <4B8310D9.4080104@redhat.com>
Date: Mon, 22 Feb 2010 18:18:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip v2 5/9] perf probe: Use elfutils-libdw for analyzing
 debuginfo
References: <20100222225320.20686.17645.stgit@localhost6.localdomain6> <20100222225354.20686.67443.stgit@localhost6.localdomain6> <4B830E6F.4020401@redhat.com> <4B830F82.70808@redhat.com>
In-Reply-To: <4B830F82.70808@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Ulrich Drepper wrote:
>> On 02/22/2010 02:53 PM, Masami Hiramatsu wrote:
>>>  - Cast Dwarf_Addr/Dwarf_Word to unsigned long long for printf-formats.
>>
>> I don't know about the use of C99 types in kernel files.  But can you
>> use uintmax_t and then PRI[douxX]MAX in printf?  It'd be more correct
>> and it exists in glibc for a very long time (1997).
> 
> Hmm, I'm not sure about that. Could you point somewhere I can refer that?

Ah, would you mean 'j' prefix? like as 'printf("%jx", (uintmax_t)Addr);' ?

> 
> Thank you,
> 

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
