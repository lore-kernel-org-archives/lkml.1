Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbYBVRv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbYBVRv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYBVRvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:51:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:56898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbYBVRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WFkgWaxkkCf5/An1TiGEvM0ArNkWTPbJwFB/nJ1SNWNeudpxGDyf3Fn2XKrHlxkSVUmw5+Mr9lUctu3tHVfX2vLvKeZZpbYVjEPoeQsY5kT9fs/CQZB+RIurC3FjILEROUFzk5LniZUa/evh+KMI/6xZa7JVMPezV2I7Yeg1BIo=
Message-ID: <47BF0BA4.5060503@googlemail.com>
Date: Fri, 22 Feb 2008 18:51:32 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
In-Reply-To: <200802221513.58608.mb@bu3sch.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Friday 22 February 2008 12:17:15 Alexey Zaytsev wrote:
>> Hello.
>>
>> The bcm43xx driver won't work any more, if the b44 Ethernet
>> driver is enabled. This happens because the b44 driver
>> needlessly enables the b43_pci_bridge code, which claims
>> the same pci ids as the bcm43xx driver. The b43_pci_bridge
>> code is needed for the b43{legacy} drivers, but for the
>> b44, only the "ssb pci core" is needed.
>>
>> This patch separates the ssb b43 pci bridge and the ssb pci
>> core config options and enables only the needed ones.
> 
> Nack. Switch to b43. bcm43xx is going to be removed anyway.

Since when this is a valid reason to NACK a patch which fixes 
a regression in the 'stable' kernel ? 

Probably you may want to ask first whatever 'b43' works for Alexey ?
and most probably the answer will be 'no' because that is the only reason 
one would want to fix the *old* one when *both* drivers are enabled.

Really 'Switch to foo' and 'foo_old will be removed sometimes' 
is not a 'valid' reason to NACK anything as long you 'have foo and foo_old' 
*supported* in that kernel.

> I'm not going to play these kconfig SELECT tricks anymore.

Fix it different then.

> We had _lots_ of bugs there. People submitted patches that
> obviously looked OK and still they turned out to break
> some dependencies. KConfig SELECT is a feature from hell.
> 

Yes it is but that is still not a valid reason to NACK that patch , I'm sorry.

Regards,

Gabriel



