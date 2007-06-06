Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbXFFMyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbXFFMyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762162AbXFFMys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:54:48 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:62854 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761469AbXFFMyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:54:47 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Wed, 06 Jun 2007 13:54:44 +0100
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
From: Keir Fraser <keir@xensource.com>
To: Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-ID: <C28C6D24.1026E%keir@xensource.com>
Thread-Topic: [Xen-devel] [patch 14/33] xen: xen time implementation
Thread-Index: AceoOdrAGSgBOhQtEdyEZAAX8io7RQ==
In-Reply-To: <4666C8E3.76E4.0078.0@novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On 6/6/07 13:46, "Jan Beulich" <jbeulich@novell.com> wrote:

>> On the other hand some timing issues on throttling are probably
>> the smallest of the users' problems when it really happens.
> 
> Not if this results in your box hanging - I think throttling is exactly
> intended
> to keep the box alive as long as possible (and I've seen throttling in action,
> with the box happily recovering from the situation - after having seen it a
> few times I checked and found the fan covered with dust).

Clamping to last returned timestamp value would be fine here. Time would go
moderately haywire for a while (lurch forwards and then stop for a while),
but wouldn't go backwards and should recover reasonably within the timescale
of the thermal event itself. I don't see an issue with just implementing
this clamping if it is needed.

 -- Keir

