Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbXBDSdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbXBDSdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 13:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXBDSdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 13:33:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46271 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbXBDSdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 13:33:09 -0500
Date: Sun, 4 Feb 2007 10:29:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
In-Reply-To: <1170613097.5217.13.camel@funkylaptop>
Message-ID: <Pine.LNX.4.64.0702041027460.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> 
 <200702031058.13830.ak@suse.de> <1170499668.31373.35.camel@funkylaptop> 
 <200702031151.17220.ak@suse.de> <1170594788.5217.4.camel@funkylaptop> 
 <Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
 <1170613097.5217.13.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-598720875-1170613768=:8424"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-598720875-1170613768=:8424
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Sun, 4 Feb 2007, Frédéric Riss wrote:
> 
> I think Andi said that adding asmlinkage on the function pointers
> shouldn't harm ia64. If you prefer wrapper functions, one of the patches
> I sent ( http://lkml.org/lkml/2007/1/30/309 ) did that, but the casting
> it uses looks clumsy.

I'm more comfortable with that one, at least for now. It's guaranteed to 
not break ia64, at least. Also, it does what I think is right: do the 
calling convention conversion at the call-site rather than at a C compiler 
level.

Will apply a whitespace-fixed version,

		Linus
---1463790079-598720875-1170613768=:8424--
