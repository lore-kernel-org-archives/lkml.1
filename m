Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbXFFMSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbXFFMSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762309AbXFFMSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:18:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762307AbXFFMSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:18:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Keir Fraser <keir@xensource.com>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
Date: Wed, 6 Jun 2007 14:18:28 +0200
User-Agent: KMail/1.9.6
Cc: Jan Beulich <jbeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <C28C5EAB.1024D%keir@xensource.com>
In-Reply-To: <C28C5EAB.1024D%keir@xensource.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061418.28967.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Yes, this could be an issue. Is there any way to get an interrupt or MCE
> when thermal throttling occurs?

Yes you can get an thermal interrupt from the local APIC. See the Linux
kernel source. Of course there would be still a race window.

On the other hand some timing issues on throttling are probably 
the smallest of the users' problems when it really happens.

Standard Linux just ignores it.

-Andi


