Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYD1JPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYD1JPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYD1JPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:15:03 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:40579 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbYD1JPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:15:01 -0400
X-Greylist: delayed 1589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 05:15:00 EDT
From: Gabriel Paubert <paubert@iram.es>
Date: Mon, 28 Apr 2008 10:46:30 +0200
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       benh@ozlabs.org, linuxppc-dev@ozlabs.org, arndb@de.ibm.com,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: cpu_clock confusion
Message-ID: <20080428084630.GA1623@iram.es>
References: <1207240450.3797.22.camel@johannes.berg> <20080404144641.GA15844@elte.hu> <1209028912.3357.52.camel@johannes.berg> <20080424.022404.151729194.davem@davemloft.net> <1209029257.3357.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209029257.3357.55.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 11:27:37AM +0200, Johannes Berg wrote:
> On Thu, 2008-04-24 at 02:24 -0700, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Thu, 24 Apr 2008 11:21:52 +0200
> > 
> > > Hmm. Why is that whole cpu_clock stuff in place anyway? powerpc has
> > > perfectly synchronised time across processors with dirt cheap access to
> > > it as well, so why build all this code that only messes it up on top of
> > > it?
> > 
> > Same on sparc64.  These changes add more bugs than they fix.
> 
> I tend to think all this clock business should be done local to those
> arches that aren't capable of providing cheap, useful synchronised and
> accurate clocks themselves. Or be a lib that they can link in if needed.
> As it stands, it seems to me that it all just penalises those
> architectures that have decent clocks.

100% agreed. 

	Gabriel
