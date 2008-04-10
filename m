Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbYDJPWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbYDJPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbYDJPWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:22:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51339 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760640AbYDJPWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:22:19 -0400
Date: Thu, 10 Apr 2008 10:22:18 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Mayer <ajm@sgi.com>, mingo@elte.hu,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
In-Reply-To: <alpine.LFD.1.00.0804091507480.3243@woody.linux-foundation.org>
Message-ID: <Pine.SGI.3.96.1080410094510.8706317N-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Linus Torvalds wrote:

> 
> 
> On Wed, 9 Apr 2008, Alan Mayer wrote:
> >
> > -	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
> > +	set_intr_gate(alloc_system_vector(RESCHEDULE_VECTOR), reschedule_interrupt);
> 
> Can we please just merge that syntax and make a single function like
> 
> 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
> 
> instead?
> 
> 		Linus

Yes, I think I can do that.

		--ajm


You'll have to have them
all pulled out,
after the Savoy truffle.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

