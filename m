Return-Path: <linux-kernel-owner+w=401wt.eu-S1031593AbXEAFgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031593AbXEAFgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031594AbXEAFgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:36:47 -0400
Received: from gw.goop.org ([64.81.55.164]:35487 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031593AbXEAFgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:36:46 -0400
Message-ID: <4636D200.3010406@goop.org>
Date: Mon, 30 Apr 2007 22:37:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, Vivek Goyal <vgoyal@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>	<1177902195.30071.203.camel@localhost.localdomain>	<463572B7.90202@zytor.com>	<1177909434.30071.216.camel@localhost.localdomain>	<m1ejm16flv.fsf@ebiederm.dsl.xmission.com>	<1177990722.28659.39.camel@localhost.localdomain> <m18xc919im.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18xc919im.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I'm not going to worry about going farther until the patches in flight
> settle down a little bit, but this looks promising.
>   

Is there any value in adding an "early-putchar" function pointer into
the structure somehow?  I could easily arrange for the domain builder to
put a bit of code into the domain so that the early boot code can emit
something.

    J
