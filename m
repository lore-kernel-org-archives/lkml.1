Return-Path: <linux-kernel-owner+w=401wt.eu-S1422820AbXCWMYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820AbXCWMYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422844AbXCWMYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:24:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56380 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422841AbXCWMYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:24:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <hansendc@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       menage@google.com, Andrew Morton <akpm@linux-foundation.org>,
       xemul@sw.ru
Subject: Re: controlling mmap()'d vs read/write() pages
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<1173806793.6680.44.camel@localhost.localdomain>
	<20070313190931.1417c012@lxorguk.ukuu.org.uk>
	<m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
	<1174062660.8184.8.camel@localhost.localdomain>
	<m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
	<1174074412.8184.29.camel@localhost.localdomain>
	<m1zm6ajvns.fsf@ebiederm.dsl.xmission.com>
	<1174407335.26166.146.camel@localhost.localdomain>
	<m13b3zmx4b.fsf@ebiederm.dsl.xmission.com>
	<46036C54.6030502@yahoo.com.au>
	<m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>
	<4603B051.8000108@yahoo.com.au>
Date: Fri, 23 Mar 2007 06:21:01 -0600
In-Reply-To: <4603B051.8000108@yahoo.com.au> (Nick Piggin's message of "Fri,
	23 Mar 2007 21:47:45 +1100")
Message-ID: <m1hcsc5exe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

>> Would any of them work on a system on which every filesystem was on
>> ramfs, and there was no swap?  If not then they are not memory attacks
>> but I/O attacks.
>>
>> I completely concede that you can DOS the system with I/O if that is
>> not limited as well.
>>
>> My point is that is not a memory problem but a disk I/O problem which is
>> much easier to and cheaper to solve.  Disk I/O is fundamentally a slow
>> path which makes it hard to modify it in a way that negatively affects
>> system performance.
>>
>> I don't think with a memory RSS limit you can DOS the system in a way
>> that is purely about memory.  You have to pick a different kind of DOS
>> attack.
>
> It can be done trivially without performing any IO or swap, yes.

Please give me a rough sketch of how to do so.

Or is this about DOS'ing the system by getting the kernel to allocate
a large number of data structures (struct file, struct inode, or the like)?

Eric
