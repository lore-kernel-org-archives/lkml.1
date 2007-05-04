Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXEDPyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXEDPyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030951AbXEDPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:54:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224AbXEDPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:54:18 -0400
Message-ID: <463B56F8.5070007@zytor.com>
Date: Fri, 04 May 2007 08:53:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type"	boot
 header field
References: <1178283582.23670.67.camel@localhost.localdomain>	 <m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com> <1178288329.23670.86.camel@localhost.localdomain>
In-Reply-To: <1178288329.23670.86.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>
>> ENTRY(startup_32)
>> #ifdef CONFIG_LGUEST_GUEST
>>         cmpl	$1, 0x23c(%esi)
>> 	je      lguest_init
>> #endif
> 
> Hi Eric!
> 
> 	Makes sense to me, but I wasn't sure... do we need to check for old
> bootloader versions and such?

So, in summary, yes, you have to check the version number before
assigning any meaning to this field.

	-hpa
