Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbXHTJ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbXHTJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXHTJ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:29:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:59212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXHTJ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:29:17 -0400
Date: Mon, 20 Aug 2007 12:23:07 +0200
From: Andi Kleen <ak@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Non atomic unaligned writes
Message-ID: <20070820102306.GG16680@bingen.suse.de>
References: <200707191105.44056.ak@suse.de> <p73d4yow0ys.fsf@bingen.suse.de> <469FC9D4.5070604@goop.org> <200707192246.58047.ak@suse.de> <20070820005522.GA5069@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820005522.GA5069@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Intel486???, Pentium??, or P6 family processors. The P6 family processors
> provide bus control signals that permit external memory subsystems to
> make split accesses atomic; however, nonaligned data accesses will

Normally in standard SMP systems between CPUs they are atomic AFAIK 
(modulo bugs) 

You're right -- i'm not sure about P5 SMP.

> seriously impact the performance of the processor and should be avoided
> where possible.

But they're also slow yes.

-Andi
