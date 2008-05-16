Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYEPINn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYEPINn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYEPIN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:13:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:60668 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYEPINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dj8GFEdLVT9ilwwWTuH+5sbPgTtdNDlv/8/p0FVauPhIii9LkAAoQ+38LyU7pH7nS1nC9Iy6t3apqshspyDLjSZ3CMIq3TXHXYEWk4wGyPkqhgyaCwdRskZ+CIp1NHNMSNO7TPf6seb2m0rGBmgYWa3XzIBhs5/aTE2yVIwqago=
Message-ID: <19f34abd0805160113i17eea98aub287f2d1be8f05d9@mail.gmail.com>
Date: Fri, 16 May 2008 10:13:22 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: spontaneous reboots and hangs on x86_64
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Adrian Bunk" <bunk@kernel.org>,
       kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200805160737.50373.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805152201.49154.m.kozlowski@tuxland.pl>
	 <20080516140625.25fac6a2.sfr@canb.auug.org.au>
	 <200805160717.31618.m.kozlowski@tuxland.pl>
	 <200805160737.50373.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 7:37 AM, Mariusz Kozlowski
<m.kozlowski@tuxland.pl> wrote:
> Hello,
>
>> > > > ~/linux/linux-next $ git bisect start
>> > > > fatal: ref HEAD is not a symbolic ref
>> > > > Bad HEAD - I need a symbolic ref
>> >
>> > This would indicate something wrong with your clone of linux-next.  How
>> > did you create the repository?
>> >
>> > > > - how does one bisect on linux-next?
>> >
>> > Any day's linux-next tree is a git tree like any other ...
>>
>> Hm it can be that I did something wrong ...
>
> and I did :/ I think I just started this repo in wrong way - according to linux-next FAQ.
> I'll just start from scratch then.

You need to be on a branch. If git-branch says this:

$ git branch
* (no branch)

then git will not allow you to bisect:

$ git bisect start v2.6.24 v2.6.25
fatal: ref HEAD is not a symbolic ref
Bad HEAD - I need a symbolic ref

Try first checkout out a new branch:

$ git checkout -b bisect
Switched to a new branch "bisect"

$ git bisect start v2.6.24 v2.6.25
Switched to branch "master"

Good luck!

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
