Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYATSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYATSzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYATSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:55:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYATSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:55:36 -0500
Message-ID: <479398D2.1040209@zytor.com>
Date: Sun, 20 Jan 2008 10:54:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org> <1200847490.26633.62.camel@cthulhu.hellion.org.uk> <20080120173938.GA27247@one.firstfloor.org> <47939787.3050707@zytor.com> <20080120185541.GA28024@one.firstfloor.org>
In-Reply-To: <20080120185541.GA28024@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> There are various loaders (kexec, elilo, ...) that skip the 16bit code
>>> and jump directly to 32bit head.S. So in theory those could hit it.
>>> But still having the loop only is probably fine.
>>>
>> It's probably just as well, since we don't really know how to get a 
>> message out in such an environment anyway...
> 
> It would be robably possible to extend the 32bit protocol to some
> way to error out in such a case. On the other hand I'm not sure it's really
> worth the considerable work to implement and debug such an addition.
> 
>>>> variant of make_pte now though.
>>> The 32bit cast still feels unclean. After all the PTE is not 32bit.
>> No, but (pte_t *) is 32 bits.  To be more "Linuxy" it probably should be 
>> (long) or (unsigned long) though.
> 
> That's not 32bit either.

Looked at the subject line?

	-hpa

