Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZKAVfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZKAVfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZKAVfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:35:09 -0500
Received: from icculus.org ([67.106.77.212]:53215 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZKAVfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:35:08 -0500
Date: Sun, 1 Nov 2009 16:35:05 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.local
To: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <yw1xhbte0wx0.fsf@unicorn.mansr.com>
Message-ID: <alpine.OSX.1.10.0911011623070.55174@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <yw1xhbte0wx0.fsf@unicorn.mansr.com>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's not the size of the kernel patch I'm worried about.  What worries
> me is the disk space needed when *all* my executables and libraries
> are suddenly 3, 4, or 5 times the size they need to be.

Then don't make FatELF files with 5 binaries in it. Or don't make FatELF 
files at all.

I glued two full Ubuntu installs together as a proof of concept, but I 
think if Ubuntu did this as a distribution-wide policy, then people would 
probably choose a different distribution.

Then again, I hope Ubuntu uses FatELF on a handful of binaries, and 
removes the /lib64 and /lib32 directories.

> There is also the issue of speed to launch these things.  It *has* to
> be slower than executing a native file directly.

In that there will be one extra read of 128 bytes, yes, but I'm not sure 
that's a measurable performance hit. For regular ELF files, the overhead 
is approximately one extra branch instruction. Considering that most files 
won't be FatELF, that seems like an acceptable cost.

> It's far too easy to use computers already.  That's the reason for the
> spam problem.

Clearly that's going to remain as a philosophical difference between us, 
so I won't waste your time trying to dissuade you.

--ryan.


