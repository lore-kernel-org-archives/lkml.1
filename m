Return-Path: <linux-kernel-owner+w=401wt.eu-S1946432AbXBCK5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946432AbXBCK5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946439AbXBCK5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:57:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:17670 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946432AbXBCK53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:57:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rjJus1Nyva91kYeSijeBxnAKU4m2sDF1nXI/OmsJ0D2WiS7sI1kafjqG2DDaaukoe4H/lmeEYGHHryGwAVDPeSqwr/NsTo0+pusdYqWnKiSHpAOcUE7LjNywN0LW2+cQswfz++xqg5AkVhVaH+/Mv5pH8S94MIX/AAsf+aShCwU=
Subject: Re: 2.6.20-rc7: known regressions
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <200702031151.17220.ak@suse.de>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	 <200702031058.13830.ak@suse.de> <1170499668.31373.35.camel@funkylaptop>
	 <200702031151.17220.ak@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Sat, 03 Feb 2007 11:57:24 +0100
Message-Id: <1170500244.31373.40.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 03 février 2007 à 11:51 +0100, Andi Kleen a écrit :
> > +
> > +typedef efilinkage efi_status_t efi_get_time_t (efi_time_t *tm,
> > +						efi_time_cap_t *tc);
> 
> I assume you have double checked it actually works? (i vaguely recall some
> issues with applying attributes to typedefs). If not you would need
> to put them to the declarations.

Of course, I tested 10 suspend/resume cycles. This is with gcc 4.1.2, I
guess other compilers could mishandle it. Would you prefer the version
putting asmlinkage inside the struct definition?

Fred.


