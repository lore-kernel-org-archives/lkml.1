Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXFFMxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXFFMxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbXFFMxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:53:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:47624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXFFMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:53:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
Date: Wed, 6 Jun 2007 14:53:20 +0200
User-Agent: KMail/1.9.6
Cc: "Keir Fraser" <keir@xensource.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       virtualization@lists.osdl.org,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "lkml" <linux-kernel@vger.kernel.org>
References: <C28C5EAB.1024D%keir@xensource.com> <200706061418.28967.ak@suse.de> <4666C8E3.76E4.0078.0@novell.com>
In-Reply-To: <4666C8E3.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061453.20798.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 14:46:59 Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 06.06.07 14:18 >>>
> >
> >> 
> >> Yes, this could be an issue. Is there any way to get an interrupt or MCE
> >> when thermal throttling occurs?
> >
> >Yes you can get an thermal interrupt from the local APIC. See the Linux
> >kernel source. Of course there would be still a race window.
> >
> >On the other hand some timing issues on throttling are probably 
> >the smallest of the users' problems when it really happens.
> 
> Not if this results in your box hanging 

Yes it shouldn't hang. Just saying that some non monotonicity in the returned
values under this abnormal condition is probably not the world's end.

-Andi
