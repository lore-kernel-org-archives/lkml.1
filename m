Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbXFFOPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbXFFOPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXFFOPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:15:42 -0400
Received: from gw.goop.org ([64.81.55.164]:33816 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXFFOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:15:41 -0400
Message-ID: <4666C183.9060008@goop.org>
Date: Wed, 06 Jun 2007 07:15:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       virtualization@lists.osdl.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, lkml <linux-kernel@vger.kernel.org>,
       Jiri Bohac <jbohac@suse.cz>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <20070522140941.802382212@goop.org> <46668EC6.76E4.0078.0@novell.com> <466686E2.4040004@goop.org> <200706061226.11326.ak@suse.de>
In-Reply-To: <200706061226.11326.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I once had some code in there to do that, implemented in very boneheaded
>> way with a spinlock to protect the "last time returned" variable.  I
>> expect there's a better way to implement it.
>>     
>
> But any per CPU setup likely needs this to avoid non monotonicity 

Yeah.  The point I didn't quite make was that this should be something
that the clock core should handle rather than dealing with it in every
clocksource.

    J

