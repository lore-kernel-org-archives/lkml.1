Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbZCTL3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbZCTL3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZCTL31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:29:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZCTL30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:29:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: fix kexec with power state D3
Date: Fri, 20 Mar 2009 12:29:16 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, linux-pci@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <49B1F934.5050006@kernel.org> <20090308110835.GB27811@elte.hu> <20090319184948.44bf5e9a@hobbes.lan>
In-Reply-To: <20090319184948.44bf5e9a@hobbes.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903201229.18962.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 March 2009, Jesse Barnes wrote:
> > > And, quite frankly, I'm not sure if users will be happy with 
> > > the $subject patch, because it _really_ breaks things (well, 
> > > the kexec users who don't use suspend might be, but surely 
> > > suspend users who don't use kexec won't).
> > 
> > Please note that i havent reviewed the patches and i did not 
> > take any sides in the discussion - i just flagged the maintainer 
> > ping-pong. As long as we pick one of the patches (or a third 
> > one) within a bound amount of time we should be fine :)
> 
> I'll defer to Rafael here; he's been working the most in this area.
> The changelog wasn't very complete for the original patch, but it
> sounds like in the kexec case the newly booted kernel will get an igb
> device in D3 which it can't handle?  That really does sound like a
> driver bug, not something we should mess with in the core.

I have already posted an alternative patch for igb that's been reported to
fix the problem.

Thanks,
Rafael
