Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXKEUbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXKEUbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXKEUbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:31:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXKEUbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:31:35 -0500
Message-ID: <472F7D8D.8050505@zytor.com>
Date: Mon, 05 Nov 2007 12:31:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org> <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>>> However, that being said, doing so is trivial, and it might help some
>>> debugging hack; anything that makes debugging easier is a Good Thing[TM].
>> Yeah. Even if it was just re-using the boot-time stack area temporarily, 
>> just to give code the choice to use a common set of instructions.
> 
> If I had to do it from scratch today I would make the 32-bit entry
> point require a stack, segments and use C calling conventions to pass
> struct boot_params *.
> 
> Besides %esi I'm not really fond of requiring anything in the 32bit
> entrypoint.  At the same time I totally agree that it is always nice
> to provide way more then you need.
> 

Nailing down the interface as hard as possible is a good idea, to avoid 
tying your hands for the future.

	-hpa
