Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbXCHTS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbXCHTS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXCHTS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:18:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097AbXCHTS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:18:26 -0500
Date: Thu, 8 Mar 2007 20:17:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Daniel Arai <arai@vmware.com>, tglx@linutronix.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308191712.GA794@elte.hu>
References: <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F05999.20803@vmware.com> <20070308191409.GI10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308191409.GI10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> > Chris, would you like to work together on this?  I don't know what 
> > Xen's requirements are for the APIC interface.  Do you think we 
> > could come up with something that would fit both of our needs, and 
> > maybe also be usable for some of the subarch-specific code?
> 
> Sure, we just have a pretty small genapic_xen, and then enough 
> (hackery, this should be sorted out) to use that genapic and have an 
> effective override for __send_IPI_shortcut.

genapic is still too lowlevel: as Thomas mentioned what we want is a 
virtual interrupt controller used by /all/ hypervisors (and mapped to 
their respective hypervisor ABIs via the backend).

	Ingo
