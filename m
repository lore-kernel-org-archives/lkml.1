Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYCJNmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYCJNmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYCJNmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:42:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29516 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYCJNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YZc4QssCn4Gdtu2bkOEPOHn364AkQ4bJRWqtJXNg5Qm9OU9FQEOrBCHA/ycnE4Qj9697fTIsj8e7v3j0Na6N5nUVSPDcHL5i6SMrrH04IcTYU1T7lxP2kd2QMlzHEDR9ZJXOt2+CYmEDxu7QU0pdPFNOP9wznnyoW2nVekFRiJ4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Date: Mon, 10 Mar 2008 14:56:48 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101336.56159.bzolnier@gmail.com> <20080310131901.0154B93C900@tippex.mynet.homeunix.org>
In-Reply-To: <20080310131901.0154B93C900@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803101456.48424.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008, Anders Eriksson wrote:
> 
> bzolnier@gmail.com said:
> >> The bisect came up with this:
> >> 
> >> 18a056feccabdfa9764016a615121b194828bc72 is first bad commit
> >> commit 18a056feccabdfa9764016a615121b194828bc72
> 
> > Hmm, this is the first commit _after_ the previous "guilty" commit
> > 852738f39258deafb3d89c187cb1a4050820d555 so it just can't be the "real bad"
> > one... 
> 
> I share the same worry. Towards the end of the bisect run (something like the
> 4-th last reboot), I was asked to try "2.6.24". Now, I _thought_ 2.6.24 was way
> before 852738f39258deafb3d89c187cb1a4050820d555, and hence it should be called
> 2.X.Y-foobaz something as the others were. Is this the way it should be, or did
> I fscked up the bisect?

8527 was merged before -rc1 so it is expected that resulting kernel was
called 2.6.24 (though it wasn't really 2.6.24) if CONFIG_LOCALVERSION_AUTO
config option is disabled (it is useful to have it enabled).

> This was a bisect run between 852738f39.. and 2.5.25-rc1. I got a string of 
> "bad"s but TWO goods, actually. Those goods sustained a number of reruns of 
> smartd (I can share the BISECT_LOG if wanted).
> 
> And how we can end up with good_start+1 as the guilty one, and STILL have two 
> good ones during the bisect run..... That's beyond me. lets just say that my 
> faith in myself and/or bisect starts to decline...
> 
> Now I'm considering a 2.6.24 .. 8527 run.

This is worth a try but please remember that the problem may not show up
immediately so it would require few tests to verify each commit (it is also
possible that the problem won't show up at all if we are unlucky).

Thanks,
Bart
