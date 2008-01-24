Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYAXRzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYAXRzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYAXRzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:55:40 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32888 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYAXRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:55:39 -0500
Message-ID: <4798D10C.6090109@davidnewall.com>
Date: Fri, 25 Jan 2008 04:25:24 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist>
In-Reply-To: <20080124172414.GD4476@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Removing dead code makes:
> - the kernel smaller,
> - the kernel faster and
> - makes it easier to maintain the non-dead code.
>   

The performance benefit is trivial, and the improvement to
maintainability is even less.

> All of these are considered useful by the people who actually 
> contribute to the Linux kernel.
>   

Contributions to the kernel take forms other than just code.  I'm
contributing in this very instance by putting the argument against
removal of code.  Once removed it'll be much harder to re-insert than to
repair in-situ.

>> At one stage iBCS2 support DID work.  Now it doesn't.  Now there's an
>> argument that the remaining infrastructure should be removed.  This is
>> the wrong direction to take.
>>     
>
> When did iBCS2 support work in a plain ftp.kernel.org kernel?
>   
I don't know when.  Are you disputing that it ever did?  I think it's a
given that once it worked.

> And if you consider iBCS2 support that important I can only repeat that 
> the language on Linux kernel are patches, not hot air.
>   

Fools believe that code is the only acceptable offering, and you, by
reputation, are not a fool.  There are plenty of examples where
suggestions made on list have value far exceeding a lot of the code. 
For that matter, some of the code that's offered is crap.  For that
matter, good contributed code too often (and in some cases famously)
gets ignored or rejected for reasons of ego.  You diminish yourself by
implying that code is the only thing that matters, and present the
impression that you know little about good development practice, in
which design effort exceeds that of coding.  I do not believe you are a
cowboy; stop talking like one.

Look at the merits of iBCS2 support.  Is it desirable?  Yes.  Is it
useful to remove what support remains?  Not particularly.  Does it
improve performance?  Trivially; almost immeasurably.   Does it improve
clarity?  No.  Does the code serve any useful purpose?  Yes, by acting
as a reminder of work still be done.  It's like the /* XXX */ comments
that are widely sprinkled through the system, only more concrete.  The
benefits of removing it do not outweigh the benefits of leaving it.
