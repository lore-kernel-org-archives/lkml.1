Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYFQPbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYFQPbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYFQPbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:31:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbYFQPbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:31:42 -0400
Date: Tue, 17 Jun 2008 11:24:50 -0400
From: Dave Jones <davej@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
Message-ID: <20080617152450.GB8063@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org> <Pine.LNX.4.55.0806142249090.3771@cliff.in.clinika.pl> <alpine.LFD.1.10.0806141654280.2949@woody.linux-foundation.org> <Pine.LNX.4.55.0806160001430.11995@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806160001430.11995@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 12:31:52AM +0100, Maciej W. Rozycki wrote:
 > On Sat, 14 Jun 2008, Linus Torvalds wrote:
 > 
 > > >  From what you have written it looks the dependency should actually be:
 > > > 
 > > > 	depends on !M386 && !M486 && !M586 && !M586TSC && !M586MMX
 > > > 
 > > > as none of the pre-Pentium-Pro processors had the PAE feature (I am not
 > > > sure about non-Intel implementations, so the case of M586 would have to be
 > > > investigated).
 > > 
 > > Yes, it's the non-intel ones that would keep me from saying !M586.
 > > 
 > > For intel, PAE was a PPro feature (at least officially, as you point out), 
 > > but I do not know about various other manufacturers. From personal 
 > > experience, the line between Pentium and PPro features doesn't tend to be 
 > > totally black-and-white (although I suspect that when it comes to PAE it 
 > > _may_ be).
 > 
 >  Well, PAE is quite a significant block to implement and Intel kept it
 > hidden until they published the long awaited PentiumPro manual sometime in
 > 1996.  I am fairly sure the K5 did not implement it (it may have had PSE 
 > and VME, especially in the later revisions) and Google does not show up 
 > any Cyrix processors with PAE.  I may have a K5 manual somewhere, so I can 
 > see if I can verify it.

Even the K6 didn't have PAE.  The Athlon was AMD's first CPU that had it.
 
 >  Please also note these processors tried to compete with Intel on the
 > desktop market where 4GB of RAM was completely unreasonable in late 90s.  
 > I think unless someone can recall a counter-example, it can be safely
 > assumed these chips did not have the PAE.  We could try to extend the
 > dependency and see if anybody screams.
 
I agree.  To the best of my knowledge (and looking through output of
x86info from lots of old CPUs), Intel had the only CPUs with PAE in
that era.

	Dave

-- 
http://www.codemonkey.org.uk
