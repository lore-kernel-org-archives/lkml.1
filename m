Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXEAHes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXEAHes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965461AbXEAHer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:34:47 -0400
Received: from ozlabs.org ([203.10.76.45]:49976 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXEAHeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:34:46 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <4636D200.3010406@goop.org>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	 <1177902195.30071.203.camel@localhost.localdomain>
	 <463572B7.90202@zytor.com>
	 <1177909434.30071.216.camel@localhost.localdomain>
	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>
	 <1177990722.28659.39.camel@localhost.localdomain>
	 <m18xc919im.fsf@ebiederm.dsl.xmission.com>  <4636D200.3010406@goop.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 17:34:28 +1000
Message-Id: <1178004868.28659.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 22:37 -0700, Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
> > I'm not going to worry about going farther until the patches in flight
> > settle down a little bit, but this looks promising.
> >   
> 
> Is there any value in adding an "early-putchar" function pointer into
> the structure somehow?  I could easily arrange for the domain builder to
> put a bit of code into the domain so that the early boot code can emit
> something.

Well there aren't that many instructions between startup_32 and
lguest_init at the moment, but I guess if we end up going through
bzImage decompression it makes more sense...

Rusty.


