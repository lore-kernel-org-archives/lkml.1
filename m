Return-Path: <linux-kernel-owner+w=401wt.eu-S1031396AbXEDQtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031396AbXEDQtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031398AbXEDQtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:49:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37270 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031396AbXEDQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:49:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot header field
References: <1178283582.23670.67.camel@localhost.localdomain>
	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
	<1178288329.23670.86.camel@localhost.localdomain>
	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>
	<463B56A0.7090805@zytor.com>
Date: Fri, 04 May 2007 10:48:38 -0600
In-Reply-To: <463B56A0.7090805@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 08:52:00 -0700")
Message-ID: <m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> Unlikely.  Unless we expect that this offset will come in non-zero.
>> 
>
> You might have to worry about that.  Historically, the "zero-page" was
> really just the setup code overwritten, and it's still true for a big
> chunk of it.
>
> One of the major changes in my setup code rewrite is to start out with
> an all-zero chunk of memory for this.

Well as long as we are in sync with setup.S we are fine.  The issue
is people generating the real-mode data from scratch, when using the
32bit entry point.

Eric
