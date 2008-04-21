Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYDUHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYDUHC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYDUHCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:02:50 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:37139 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYDUHCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:02:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:To:Cc:Subject:References:In-Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
	b=UpQGjIG4q2/Lyeo1GOzozLweCmLmZNBRcD88WwL1bk8SAHlSTmTkIoqO/AsYbnd5iSZ620RCC/K+mwynMZlf+tJJS4Lw5ReWwPNgUkjTx3XNdMhZIyTySkFt3w1jZe4RgLzmeTajIDApotKu5MEnCJV2tXVXG+YXfRgQ7Uh4b84=;
Message-ID: <20080421080101.htzh4s03snescog4@unsolicited.net>
Date: Mon, 21 Apr 2008 08:01:01 +0100
From: David R <david@unsolicited.net>
To: serge@hallyn.com
Cc: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com>
	<480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com>
In-Reply-To: <20080421000055.GA17510@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting serge@hallyn.com:

> Quoting David (david@unsolicited.net):
>> Casey Schaufler wrote:
>>> Do you have a libcap that reflects the change from 32 capabilities
>>> to 64? You'll be looking for libcap.so.2.06 or thereabouts.
>>>
>> Adding libcap-2.08 and recompiling ntpd has fixed the issue, and I'm now
>> running normally, thanks!
>
> I don't understand why, though.  Looking at the ntpd code (ntp-4.2.4p4)
> it just does a cap_set_proc(cap_from_text("X=epi"));  It should simply
> be sending in the _LINUX_CAPABILITY_VERSION which shipped with libcap,
> which should have been _V1, and the kernel should honor that so long as
> you didn't try to send in caps > 31, which ntpd wasn't.
>
>> Was this userspace visible change planned in advance for 2.6.25 ? ... as I
>> guess a few other people with venerable old userspace components may come
>> across this issue.
>>
>> Cheers
>> David
>
> It's been in the works a long time and we thought we'd done pretty
> well with backward compatibility.  I really don't see why you had
> that failure!
>
> Do you know which version of libcap you had before?

/lib/libcap.so.1 -> libcap.so.1.92

I guess that's 1.92 (should be the version shipped with SuSE 9.1).

Cheers
David

