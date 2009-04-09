Return-Path: <linux-kernel-owner+w=401wt.eu-S1765042AbZDIOWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765042AbZDIOWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZDIOVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:21:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:18317 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZDIOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q/5RAAg34sxyHan/Qy1gPIsLYOGCCNC7VKWCD1B7DvrsTJppkmgIVmsWBZs67mFA72
         MxdbRK+N6lZEAD+58WfP7KtZt/AVgzLn6tBYrkq+MpCI2+ouHBZdeB9VbHMRODa+GcGg
         H03QYpbt80VHgTRiGHgssqzjEmZAXyOQRQc3k=
MIME-Version: 1.0
In-Reply-To: <19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
References: <200903301936.08477.cova@ferrara.linux.it>
	 <19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
Date: Thu, 9 Apr 2009 16:21:47 +0200
Message-ID: <19f34abd0904090721i1e2976dbka7780cb09319c531@mail.gmail.com>
Subject: Re: [BUG] spinlock lockup on CPU#0
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Fabio Coatti <cova@ferrara.linux.it>
Cc: Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/9 Vegard Nossum <vegard.nossum@gmail.com>:
> 2009/3/30 Fabio Coatti <cova@ferrara.linux.it>:
>> Hi all, I've got the following BUG: report on one of our servers running
>> 2.6.28.8; some background:
>> we are seeing several lockups in db (mysql) servers that shows up as a sudden
>> load increase and then, very quickly, the server freezes. It happens in a
>> random way, sometimes after weeks, sometimes very quickly after a system
>> reboot. Trying to discover the problem we installed latest (at the time of
>> test) 2.6.28.X kernel and loaded it with some high disk I/O operations (find,
>> dd, rsync and so on).

[...]

>> Could someone give us some hints about this issue, or at least some
>> suggestions on how to dig it? Of course we can do any sort of testing and
>> tries.
>
> You _could_ also try something like the attached patch. It's
> completely untested, and could lead to data loss (depending on whether
> the callers of this function expects/handles the error condition
> gracefully). I really have no idea. If you try, be sure to back up
> your data first. Good luck :-)

Actually, I think you can forget about this patch. At least that's not
the point of problem in the stack-trace you posted. (My suggestion of
trying a different filesystem still holds, though.)

:-/


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
