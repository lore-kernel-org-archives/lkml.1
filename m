Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbXISKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbXISKwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXISKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:51:42 -0400
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:49508 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758634AbXISKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:51:40 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 06:51:40 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <46F09EA1.7060606@goop.org>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <200709181257.41530.ak@suse.de>
	 <1190151272.7262.175.camel@localhost.localdomain>
	 <200709182352.25118.ak@suse.de>  <46F09EA1.7060606@goop.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 11:43:00 +0100
Message-Id: <1190198580.13585.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 20:59 -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > At least the Xen port seems to have specific requirements
> > and essentially only work on xen-unstable (?) [or at least
> > some very new Xen version] which probably very few
> > people use.
> >   
> 
> Only on 64-bit hosts, because of bugs in the 64-bit compat layer. 
> 32-on-32 and 64-on-64 (when its done) should work fine.

All the required fixes for 32on64 are queued for Xen 3.1.1 too. The
proposed updates are at
http://xenbits.xensource.com/xen-3.1-testing.pq.hg

Ian.

-- 
Ian Campbell
Current Noise: Detonation - Sword-Carved Skin

The executioner is, I hear, very expert, and my neck is very slender.
		-- Anne Boleyn

