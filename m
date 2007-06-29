Return-Path: <linux-kernel-owner+w=401wt.eu-S933774AbXF2SLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbXF2SLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbXF2SLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:11:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45768 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbXF2SLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:11:00 -0400
Date: Fri, 29 Jun 2007 20:12:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] cross-architecture ELF clean up
Message-ID: <20070629181205.GA16724@uranus.ravnborg.org>
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org> <Pine.LNX.4.64.0706251531110.4386@scrub.home> <468168FD.1080200@goop.org> <Pine.LNX.4.64.0706280027100.4890@scrub.home> <4683D78E.6080309@goop.org> <Pine.LNX.4.64.0706282319350.1817@scrub.home> <46851CF3.2070608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46851CF3.2070608@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 10:53:39AM -0400, Jeremy Fitzhardinge wrote:
> Roman Zippel wrote:
> >The problem I have is that you want to separate _all_ constants, which 
> >doesn't really make sense to me, because many of them are useless without 
> >the correspending structures.
> >  
> 
> It seems cleanest to just put all the constants in one place rather than 
> scatter them around based on how they happen to be used.

Grouping related things together is always a good approach. But the right
factor should be used for the grouping. For the ELF file is would from a usage
perspective be natural to have constants close to the definition that
they are used to describe. Having constants grouped with other constants just
_because_ they are constants does not cut here.

	Sam
