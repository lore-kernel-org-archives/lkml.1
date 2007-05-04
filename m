Return-Path: <linux-kernel-owner+w=401wt.eu-S1030820AbXEDPxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820AbXEDPxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030878AbXEDPxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:53:01 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030820AbXEDPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:53:00 -0400
Message-ID: <463B56A0.7090805@zytor.com>
Date: Fri, 04 May 2007 08:52:00 -0700
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
References: <1178283582.23670.67.camel@localhost.localdomain>	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>	<1178288329.23670.86.camel@localhost.localdomain> <m1tzussm4z.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzussm4z.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Unlikely.  Unless we expect that this offset will come in non-zero.
> 

You might have to worry about that.  Historically, the "zero-page" was
really just the setup code overwritten, and it's still true for a big
chunk of it.

One of the major changes in my setup code rewrite is to start out with
an all-zero chunk of memory for this.

	-hpa
