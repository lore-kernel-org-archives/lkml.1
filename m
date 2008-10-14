Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYJNF7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYJNF7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYJNF7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:59:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44390 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYJNF7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:59:36 -0400
Date: Tue, 14 Oct 2008 08:06:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hans Schou <linux@schou.dk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
Message-ID: <20081014060616.GO12131@one.firstfloor.org>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org> <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Your attachment seems to be windows line end damaged.
> 
> Strange, Pine usually do it right with file attachments.

It likely was added on some Windows system.

> (what is "windows line end damaged"?)

It used MSDOS style \r\n line terminators instead of Unix style \n.

> 
> >Also the changes are so small that it's not worth adding a CONFIG 
> >for it. Just add it unconditionally.
> 
> I was not trying to invent anything. It is almost a copy of the UMC 
> CPU, except that it is 586 code.

Then the comment applies to that one too.

> 
> >And hardcoding the cache size for all of SiS seems a bit extreme. 
> >What happens when SiS ever brings out another part with different 
> >caches? Ideally figure out some way to detect this particular CPU 
> >and only use 8 KB only for that. Alternatively ignore it (there's 
> >nothing really in the kernel that uses the cache sizes anyways)
> 
> In that case the cache could be deleted.
> 
> One annoying thing is that the "model name" in /proc/cpuinfo is 
> written as "00/55" instead of "SiS55x" when the CPU is not detected.

Is that really so bad?

> 
> The worst problem is that an unknown CPU writes:
> printk(KERN_ERR "CPU: Your system may be unstable.\n");

Perhaps it would be better to just remove that printk.
Its truth seems doubtful.

> and the SiS55x is not unstable. Not until now at least and it has been 
> on the market for 5 years.
> 
> Maybe the message could be changed to something less catastrophic when 
> CPU is unknown.

Yes that would be a good idea.

-Andi
