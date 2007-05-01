Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbXEAID0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbXEAID0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXEAIDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:03:25 -0400
Received: from gw.goop.org ([64.81.55.164]:60317 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbXEAIDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:03:21 -0400
Message-ID: <4636F45A.50003@goop.org>
Date: Tue, 01 May 2007 01:03:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>	 <1177902195.30071.203.camel@localhost.localdomain>	 <463572B7.90202@zytor.com>	 <1177909434.30071.216.camel@localhost.localdomain>	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>	 <1177990722.28659.39.camel@localhost.localdomain>	 <m18xc919im.fsf@ebiederm.dsl.xmission.com>  <4636D200.3010406@goop.org> <1178004868.28659.57.camel@localhost.localdomain>
In-Reply-To: <1178004868.28659.57.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Well there aren't that many instructions between startup_32 and
> lguest_init at the moment, but I guess if we end up going through
> bzImage decompression it makes more sense...

Yes, that's what I was thinking.  If we boot compressed kernels in a
novel environment, there's going to be plenty of early debugging going
on.  Fortunately for me, I can just start it up under gdb, so it isn't
all that arduous.

    J

