Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYDCMzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYDCMzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYDCMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:55:48 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:22481 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYDCMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n+k0UIqxYQVIOGfYQmjuA7vskDMy5VgMi9pOPFOnSRoepqv7MIbcdlp970dI6IGqlzPHSu5EYfLhMo+TH7aIvYRwD8wr8d6cfFTg2aSvUa7jzWlAzAYZZmeRguXZlUGZ+MNhEmp4EL1IYmTZmvC46twSEaWH0wEdMXO21Hh3awc=
Subject: Re: Linux 2.6.25-rc8
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davej@redhat.com
In-Reply-To: <18420.22563.895489.490165@cargo.ozlabs.ibm.com>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
	 <18418.44094.156352.405647@cargo.ozlabs.ibm.com>
	 <alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org>
	 <18420.22563.895489.490165@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 07:55:37 -0500
Message-Id: <1207227337.3224.6.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 15:08 +1100, Paul Mackerras wrote:
> Linus Torvalds writes:
> 
> > Well, that part isn't the one that I think is bothersome - I just wonder 
> > if the whole "defconfig" mess is worth keeping with the kernel at _all_.
> > 
> > It also causes tons of noise whenever I happen to do something like "git 
> > grep CONFIG_XYZZY" to see where some config variable is used etc.
> > 
> > So I was more wondering whether maybe there could be better ways of doing 
> > that whole thing. 
> 
> Having the defconfigs seems to be useful for the embedded folks,
> judging by the number of defconfigs they have.  They generally have a
> defconfig for each reference board.

I'm thinking of getting rid of the board specific defconfigs for PowerPC
4xx actually.  We already have ppc44x_defconfig that builds most boards,
and ppc40x_defconfig will be coming soon.

Of course, that might not be possible for other architectures to do.

> Those defconfigs would be much smaller and change much less often if
> they could be expressed as a delta from some other defconfig.  So we'd
> end up with a small number of base defconfigs plus a set of board
> defconfigs that would say effectively "use the options from that other
> defconfig, plus turn this on and that off".

IIRC, Fedora builds their kernels using such a mechanism, though it's
done in the RPM specfile with a perl script.  Maybe that's something to
look at to start with.

josh

