Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbYDCSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbYDCSSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDCSSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:18:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48069 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYDCSSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:18:32 -0400
Date: Thu, 3 Apr 2008 20:18:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davej@redhat.com
Subject: Re: Linux 2.6.25-rc8
Message-ID: <20080403181830.GA32397@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org> <18418.44094.156352.405647@cargo.ozlabs.ibm.com> <alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org> <18420.22563.895489.490165@cargo.ozlabs.ibm.com> <1207227337.3224.6.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207227337.3224.6.camel@vader.jdub.homelinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Those defconfigs would be much smaller and change much less often if
> > they could be expressed as a delta from some other defconfig.  So we'd
> > end up with a small number of base defconfigs plus a set of board
> > defconfigs that would say effectively "use the options from that other
> > defconfig, plus turn this on and that off".
> 
> IIRC, Fedora builds their kernels using such a mechanism, though it's
> done in the RPM specfile with a perl script.  Maybe that's something to
> look at to start with.
kconfig allready allow you to override values simply by appending to
the end of the .config file.
So it is a matter of creating the proper stuff around to:
1) use it
2) make is simple to update defconfigs
   A simple extract delta between two config

I'm not up to do that at the moment - but it is doable.
And I would hate to see the defconfig disappear just because
they are so visible in Linus' dirstat.
	Sam
