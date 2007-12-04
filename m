Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXLDULw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXLDULw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbXLDULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:11:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:46394 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbXLDULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VCnbz/Uhny50bfhZNdCT8nEEV5T+RadQOKKCyHK1Y9SGNc+0SZglGvEhfgtS6n2QO1+n9I65tEgs5C/UjTAocLVLy0CLzq38PelsN9YKrvPJXvOKWaZ6kxVBdDo2xQ4jIiafh/91jJv0T+oJ0RGXaGsvW5l+AHQF0VJEFKoKf90=
Message-ID: <4755B508.9020806@gmail.com>
Date: Tue, 04 Dec 2007 21:14:00 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
References: <Pine.LNX.4.44L0.0712041424270.13516-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0712041424270.13516-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote, On 12/04/2007 08:28 PM:

> On Tue, 4 Dec 2007, Jarek Poplawski wrote:

...

> But you have to consider hypothetical kernel bugs.  That's exactly what 
> lockdep is for -- to warn you about possible deadlocks that could be 
> caused by bugs.
> 
> As a simple example, if thread #1 does "lock(A); lock(B)" and thread 
> #2 does "lock(B); lock(A)" then there's a possible bug.  Lockdep should 
> warn about you, and it does -- even if those two threads can never run 
> at the same time.
> 
> If lockdep warned about deadlocks only when they actually happened, it 
> wouldn't be nearly so useful.


Sure! I probably missed your point... Lockdep always names reported locks,
so I meant 'hypothetical' only trying to explain lockdep with some other,
unknown or unnamed bugs.

So, depending on the code, above example with A & B could be a real bug
(even if very improbable but logically justified) or a false alarm (eg.
when we know both threads could never work at the same).

Jarek P.
