Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZKAVZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZKAVZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZKAVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:25:36 -0500
Received: from agrajag.mansr.com ([78.86.181.102]:55674 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZKAVZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:25:30 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Nov 2009 16:25:29 EST
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Sun, 01 Nov 2009 21:15:07 +0000
In-Reply-To: <alpine.OSX.1.10.0911011540400.53392@caridad.local> (Ryan C. Gordon's message of "Sun, 1 Nov 2009 15:59:56 -0500 (EST)")
Message-ID: <yw1xhbte0wx0.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ryan C. Gordon" <icculus@icculus.org> writes:

>> Am I the only one who sees this as nothing bloat for its own sake?
>
> I posted a fairly large list of benefits here:  http://icculus.org/fatelf/

I've read the list, and I can't find anything I agree with.  Honestly.

> Some are more far-fetched than others, I will grant. Also, I suspect most 
> people will find one benefit and ten things they don't care about, but 
> that benefit is different for different people. I'm confident that the 
> benefits far outweigh the size of the kernel patch.

It's not the size of the kernel patch I'm worried about.  What worries
me is the disk space needed when *all* my executables and libraries
are suddenly 3, 4, or 5 times the size they need to be.

There is also the issue of speed to launch these things.  It *has* to
be slower than executing a native file directly.

>> Did I miss a massive drop in intelligence of Linux users, causing them
>> to no longer be capable of picking the correct file themselves?
>
> Also known as "market saturation."   :)
>
> (But really, there are benefits beyond helping dumb people, even if 
> helping dumb people wasn't a worthwhile goal in itself.)

It's far too easy to use computers already.  That's the reason for the
spam problem.

Besides, clueless users would be installing a distro, which could
easily download the correct packages automatically.  In fact, that is
what they already do.  The bootable installation media would still
need to be distributed separately, since the boot formats differ
vastly between architectures.  It is not possible to create a CD/DVD
that is bootable on multiple system types (with a few exceptions).

>> As an embedded systems guy, I'm more concerned about precious flash
>> space going to waste than about some hypothetical convenience.
>
> I wouldn't imagine this is the target audience for FatELF. For embedded 
> devices, just use the same ELF files you've always used.

Of course I will.  The question is, will everybody else?  I'm seeing
enough bloat in the embedded world as it is without handing out new
ways to make it even easier.

-- 
Måns Rullgård
mans@mansr.com
