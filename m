Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYL2XPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYL2XPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYL2XPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:15:40 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:8613 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYL2XPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BHmHUtoXLn3Q2xH3NaAxULkoHMWVIcr0aFE5SgyCBh+9iJ7WG+zCFFVd1jx6W1rWKM
         G9JNW/YYoiA5EW3sfM8f9bAcMLF+ok4hJWOjAhta9PnWbkwY0gBkMMxjmHLE5KbovAhB
         oWSx9aJTL1bwJ9Hy7H7giE1j71OuFocMaw0CI=
Message-ID: <9929d2390812291515y623d6a51yed1bef021ab6847e@mail.gmail.com>
Date: Mon, 29 Dec 2008 15:15:37 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [GIT]: Networking
Cc: "Andreas Mohr" <andi@lisas.de>, "David Miller" <davem@davemloft.net>,
       torvalds@linux-foundation.org, bunk@kernel.org,
       auke-jan.h.kok@intel.com, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081229091728.d869f1c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081228.000118.121541932.davem@davemloft.net>
	 <20081229102515.GA17171@rhlx01.hs-esslingen.de>
	 <20081229091728.d869f1c1.akpm@linux-foundation.org>
X-Google-Sender-Auth: ad546667766da6a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 9:17 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 29 Dec 2008 11:25:15 +0100 Andreas Mohr <andi@lisas.de> wrote:
>
>> Hi,
>>
>> > Adrian Bunk (1):
>> >
>> >       The overdue eepro100 removal.
>>
>> That would be a rather pronounced NAK then? (sorry ;)
>> (reason: rendering my web surfing box useless due to networking loss,
>> see thread "[RFC/PATCH] e100 driver didn't support any MII-less PHYs...")
>>
>> AFAICS e100 is still "non-MII"-challenged (2.6.28 doesn't appear to have
>> the necessary changes, and this pull doesn't seem to contain updates either),
>> and a long chain of attempts to get this resolved hasn't worked yet.
>
> I didn't know about this, and that patch has been around for a
> loooooooong time.  Please make more noise about these things.
>
>>
>> Somehow I seem to hit some nice walls getting my stuff into kernel.
>> - e100 MII
>
> What's that?  Does it make your web surfing work again?

He is referring to a patch to add support for devices which do not use
the MII interface which use an Intel MAC.  I have the patch in my
local tree and have been keeping it up-to-date.  I should have an
update on this patch after the New Year.

-- 
Cheers,
Jeff
