Return-Path: <linux-kernel-owner+w=401wt.eu-S934372AbXFFMqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbXFFMqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764121AbXFFMqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:46:18 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:48131 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763550AbXFFMqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:46:18 -0400
Message-Id: <4666C8E3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 06 Jun 2007 14:46:59 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>, "Keir Fraser" <keir@xensource.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <virtualization@lists.osdl.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <C28C5EAB.1024D%keir@xensource.com>
 <200706061418.28967.ak@suse.de>
In-Reply-To: <200706061418.28967.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 06.06.07 14:18 >>>
>
>> 
>> Yes, this could be an issue. Is there any way to get an interrupt or MCE
>> when thermal throttling occurs?
>
>Yes you can get an thermal interrupt from the local APIC. See the Linux
>kernel source. Of course there would be still a race window.
>
>On the other hand some timing issues on throttling are probably 
>the smallest of the users' problems when it really happens.

Not if this results in your box hanging - I think throttling is exactly intended
to keep the box alive as long as possible (and I've seen throttling in action,
with the box happily recovering from the situation - after having seen it a
few times I checked and found the fan covered with dust).

>Standard Linux just ignores it.

Jan

