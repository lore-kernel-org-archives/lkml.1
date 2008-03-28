Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYC1U6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYC1U6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYC1U5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:57:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:35796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753870AbYC1U5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:57:49 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19ek6dAZiJeIyd5dvFB+xeSbHaLl8+hfIeFzfBMYg
	O0sYDxgU/lscIU
Date: Fri, 28 Mar 2008 21:57:46 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Oops/Warning report for the week of March 28th 2008
Message-ID: <20080328205746.GA31237@atjola.homenet>
References: <47ED3F1A.1090101@linux.intel.com> <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.03.28 13:21:38 -0700, Linus Torvalds wrote:
> On Fri, 28 Mar 2008, Arjan van de Ven wrote:
> > 
> > Rank 1: input_release_device
> > 	This appears to be a regression in 2.6.25; the first reports show up
> > in 2.6.25-rc2		Often a warning at kernel/mutex.c:134
> > (mutex_lock_nested), but some oopses too
> 
> The oopses (at least some of them) seem to be a use-after-free where we 
> seem to do a list_add() on an already-released list head (or we didn't 
> remove the previous/next entry from a list before we free'd it, and then 
> the next list_add() will follow a bogus pointer).
> 
> > http://www.kerneloops.org/searchweek.php?search=input_release_device
> 
> The problem with kerneloops is that it seems to be really hard to figure 
> out the *source* of the oops. I can find the oopses (and it's really good 
> with the whole search-and-clump-together-by-version thing), but then when 
> some oops like this is found, it's hard to see where your kerneloops 
> scripts found the oops from, so the context of the oops is all gone.
> 
> Is there something obvious that I'm missing? I'd really like to see the 
> whole posting that the oops came from. Do you save the originals or even 
> just message ID's from the ones you pick from emails?

The oops for that one seem to be all coming from fc9 systems, which
(IIRC) include the automatic kerneloops reporting tool, so there
probably is no mail for them. Those that come from a mailing list
usually have a link at the top, for example this one:
http://www.kerneloops.org/raw.php?rawid=5735&msgid=http://mid.gmane.org/20080327230430.GA28795@codemonkey.org.uk

Björn
