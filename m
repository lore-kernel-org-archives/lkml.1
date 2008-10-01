Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYJAPhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYJAPhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYJAPhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:37:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:60887 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752424AbYJAPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:37:21 -0400
Date: Wed, 1 Oct 2008 17:37:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: Linux 2.6.27-rc8
In-Reply-To: <B27EBC40D200ED48A3F4CC2EBEABAE0B157C5019@orsmsx501.amr.corp.intel.com>
Message-ID: <alpine.LNX.1.10.0810010935560.4022@jikos.suse.cz>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <alpine.LNX.1.10.0809300859590.4022@jikos.suse.cz>
 <m3d4ilk9n5.fsf@maximus.localdomain> <alpine.LNX.1.10.0809301610300.4022@jikos.suse.cz> <B27EBC40D200ED48A3F4CC2EBEABAE0B157C5019@orsmsx501.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Allan, Bruce W wrote:

> > > > So far it seems to be that you need 1) something close to xorg 7.4 
> > > > and 2) 2.6.27-rcX kernel to trigger it. Not every system having 
> > > > e1000e is affected.
> > > And this e1000e must be ICH*, right? I.e. not a separate e1000e 
> > > chip/card?
> > So far all the affected systems I am aware of were ICH.
> Ditto here, i.e. we have no similar reports on other parts.

We have received another report [1] a few hours ago, which really looks 
very much like the very same corruption, but it happened on system with 
nVidia card, for the first time whatsoever! So it now really looks like 
that we could rule out at least the xorg Intel driver, if this is really 
the same bug. Now go guess.

I am trying to get more information about the system in question.

[1] https://bugzilla.novell.com/show_bug.cgi?id=425480#c105

-- 
Jiri Kosina
SUSE Labs
