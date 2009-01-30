Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZA3Quj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZA3Quj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZA3Qua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:50:30 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:28121 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZA3Qua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:50:30 -0500
Message-ID: <49832F8A.9030504@oracle.com>
Date: Fri, 30 Jan 2009 08:49:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>  <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <1233304450.4495.147.camel@laptop> <alpine.LFD.2.00.0901300844020.3150@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901300844020.3150@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49832F90.00CB:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 30 Jan 2009, Peter Zijlstra wrote:
>>> +       vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
>>> +       if (vma)
>>> +               goto out;
>> You've made checkpatch unhappy ;-)
> 
> Yeah, we need to fix that piece of crud.
> 
> checkpatch, that is.

It's just advisory, fwiw.

> I think "git grep" is more important than the "ooh, I have a tiny d*ck, 
> everybody else should have one too" argument against larger terminals.

and fix the Documentation/CodingStyle recommendations?

-- 
~Randy
