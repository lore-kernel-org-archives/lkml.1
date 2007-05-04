Return-Path: <linux-kernel-owner+w=401wt.eu-S1161904AbXEDTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161904AbXEDTPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161907AbXEDTPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:15:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161904AbXEDTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:15:50 -0400
Message-ID: <463B8629.3090309@zytor.com>
Date: Fri, 04 May 2007 12:14:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot
 header field
References: <1178283582.23670.67.camel@localhost.localdomain>	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>	<1178288329.23670.86.camel@localhost.localdomain>	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>	<463B56A0.7090805@zytor.com>	<m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>	<463B69AB.2030706@zytor.com>	<m1vef8phjy.fsf@ebiederm.dsl.xmission.com>	<463B81BC.1030504@zytor.com> <m1d51gpfqn.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d51gpfqn.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> And now you understand why I am surveying these things and want to get
> the 32bit entry point well documented.  So the situation doesn't get worse.
> 
> Frankly while I consider what we are doing pretty sane I have always considered
> the 32bit entry point at least partly experimental.  But we have enough users
> of it now and enough reasons to have users of it, that it looks like we need to
> do things a little more methodically.
> 

Indeed.  I think, yes, what has been there up to now has pretty much
been at least in part experimental, and I fear there will be unavoidable
breakage as part of sanitizing it.  C'est la vie, I guess.

>>> And 4K seems to be our maximum size for backwards compatibility.  Although
>>> we use it in a fairly sparse way, so we should be ok.
>> Sort of.  It's pretty full.
> 
> True.  For small little extensions we have room.  For big things probably
> not.

For big extensions we'll probably have to go the pointer route already
done with the command line.

	-hpa
