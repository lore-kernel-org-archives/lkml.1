Return-Path: <linux-kernel-owner+w=401wt.eu-S934517AbZC0CFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbZC0CFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZC0CFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:05:20 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:52878 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbZC0CFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:05:18 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Make relatime default
Date: Fri, 27 Mar 2009 03:05:09 +0100
User-Agent: KMail/1.9.9
Cc: alan@lxorguk.ukuu.org.uk, mjg@redhat.com, tytso@mit.edu, mingo@elte.hu,
       jack@suse.cz, akpm@linux-foundation.org, arjan@infradead.org,
       a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
       oleg@redhat.com, roland@redhat.com
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk> <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain>
In-reply-To: <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903270305.14392.elendil@planet.nl>
X-OriginalArrivalTime: 27 Mar 2009 02:05:15.0135 (UTC) FILETIME=[782298F0:01C9AE80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, you wrote:
> On Fri, 27 Mar 2009, Frans Pop wrote:
> > I guess users and distros can still elect not to set it as default,
> > but it still seems a bit like going from one extreme to another.
>
> Why? RELATIME has been around since 2006 now. Nothing has happened.
> People who think "we should leave it up to user land" lost their
> credibility long ago.

As I think Andrew already noted, the discussion today is largely a rehash 
of one in 2007, summarized by lwn [1] and kerneltrap [2]. That's also 
when Ingo first submitted the patch (based on a suggestion from you). But 
it has been blocked by others twice, and for exactly the same reasons.

relatime *without* the 24-hour safeguard has unanimously been deemed 
unsuitable as a default by distros.
So the real problem is that nobody ever did the work needed to make Ingo's 
original patch acceptable to the fs devs and the resulting stalemate for 
the last 1 3/4 years. IMO that's mainly a kernel community failure and 
not a user land failure. You've now at least broken that stalemate.

Your statement is also not quite true. At least Ubuntu has had relatime 
enabled by default for new installations for a couple of releases. And 
AFAICT they now even have it enabled by default now in their kernel 
config, but I'm not entirely sure.

For Debian Lenny (current stable release), relatime is a mount option that 
can be activated during new installs (admittedly only if you look hard 
enough). All that would have been needed for Debian to enable relatime by 
default for new installs was to have something like the *first* patch of 
the three you've now committed to have been included in 2.6.26.

Cheers,
FJP

[1] http://lwn.net/Articles/244829/
[2] http://kerneltrap.org/node/14148
