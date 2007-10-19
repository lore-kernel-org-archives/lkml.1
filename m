Return-Path: <linux-kernel-owner+w=401wt.eu-S1764119AbXJSQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764119AbXJSQjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbXJSQji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:39:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbXJSQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:39:38 -0400
Message-ID: <4718DDB7.7070707@redhat.com>
Date: Fri, 19 Oct 2007 12:39:19 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86_64 and AMD with C1E
References: <20071001101532.025d652f@localhost>
In-Reply-To: <20071001101532.025d652f@localhost>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2007 02:15 AM, Mikhail Kshevetskiy wrote:
> Hello,
> 
> I have ASUS F3T notebook with dualcore AMD processor. It has c1e feature
> enabled. I test linux-2.6.23-rc8-hrt1 kernel. Everything is work (thanks
> to lapic disable patch), but i have to many processor interrupts per 
> seconds (about 260 additional timer interrupts). 
> 
> The same situation can be observed for linux-2.6.22. Moreover the same
> problem exist with i386 kernel (test with 2.6.21, 2.6.22, 2.6.22-hrt6,
> 2.6.23-rc5-hrt1).
> 
> The problem disappear when I disable c1e on both cores. In this case 
> lapic is not disabled. The back side of this patch is the disabling of
> all C-state including C1. As result the power consumption increase from
> 23 (c1e enabled) to 27 (c1e disabled) watts.
> 
> I fill something wrong here.
> Is it possible to reduce the amount of timer interrupts?
> Is it possible to force enable C1,C2 and C3 states when c1e disabled?
> 

How are you disabling C1E?

