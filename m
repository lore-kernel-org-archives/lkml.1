Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbXJWWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbXJWWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXJWWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:32:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXJWWcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:32:24 -0400
Message-ID: <471E766F.7020203@zytor.com>
Date: Tue, 23 Oct 2007 15:32:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org> <471E729F.3000105@zytor.com> <471E73AB.4050100@goop.org>
In-Reply-To: <471E73AB.4050100@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> No, he doesn't.  The boot protocol version is communication between
>> the boot loader and the kernel (specifically, it is communication FROM
>> the kernel TO the bootloader), not between internal bits of the
>> kernel.  Th
> 
> So the bootloader will only fill out fields the kernel claims to understand?
> 

Correct.  If it fails to respect this restriction, it might even 
overwrite kernel code.  To make the bootloader's job easier, we have 
retconned the jump instruction at the beginning of the header to also be 
a limit marker.

	-hpa
