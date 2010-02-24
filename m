Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0BXAqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:46:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36957 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab0BXAqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:46:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gEQKQcziImvKZvhcTlME8cmqYLctfdNsgFKiLQDJcGpyuq6nvlu2+ehGE7+xDxK8Cd
         bGNdh8YT5NuJAp+fIfgdZ87pbzmvG+L8HZK6yiN9PN20VodtQVHVPeyhm6arxzJukRqg
         oQacQd3wVyDBtTJk9vRqPEuK31hmk//U2jTWE=
MIME-Version: 1.0
In-Reply-To: <1266956239.26106.11.camel@cndougla-ubuntu>
References: <4B83F8A1.8050503@canonical.com> <43e72e891002231202t166ff48ewb67c45863682732f@mail.gmail.com> 
	<1266956239.26106.11.camel@cndougla-ubuntu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Feb 2010 16:46:26 -0800
Message-ID: <43e72e891002231646w269a1132i505ca5c21ab22bc@mail.gmail.com>
Subject: Re: linux-firmware-nonfree: Add prism54 softmac firmware
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
       Christian Lamparter <chunkeey@web.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       debian-kernel@lists.debian.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 12:17 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On Tue, 2010-02-23 at 12:02 -0800, Luis R. Rodriguez wrote:
>> On Tue, Feb 23, 2010 at 7:47 AM, Chase Douglas
>> <chase.douglas@canonical.com> wrote:
>> > I have uploaded a new version of the linux-firmware-nonfree package to:
>> >
>> > http://kernel.ubuntu.com/~cndougla/linux-firmware-nonfree/
>> >
>> > The new package includes the firmware for prism54 softmac cards. The firmware
>> > was removed from linux-firmware due to it missing a proper license statement. I
>> > did not copy over the old prism54 (non-softmac) firmware because it has been
>> > superseded by the softmac firmware and is no longer useful in the Lucid kernel
>> > version.
>>
>> Hey is PRISM54 no longer compiled in a module any more? I had set it
>> for removal on the feature removal schedule but  I wanted to give you
>> the heads up we've received a few reports of users unable to use
>> prism54 over p54pci. It was theorized this would happen but we didn't
>> have any confirmation, which is why we just didn't remove it.
>>
>> How would you guys deal with having both enabled.
>
> Thanks for looking into this. I was going off of [1], which stated that
> the debian kernel does not include the prism54 module anymore.

Fun, passing this as a memo to lkml/Debian -- p54pci doesn't seem to
work well for *all* Prism54 FullMAC cards. They technically are the
same and the SoftMAC functionality was possible through a smaller
firmware. But it seems some cards have issues still with p54pci so I
would still enable prism54 as a module but not sure what to recommend
about dealing with two modules on the system for the same device.

> I checked
> the lucid kernel and we do have prism54 built as a module still. So, are
> we going to leave the prism54 module in, in which case we need to
> restore the prism54 firmware?

Yes I'd restore the prism54 firmware until the coast is clear with
p54pci for all. Its not the case so far as per reports.

> Or are we going to remove it, in which
> case the firmware package I uploaded was fine? I'm assuming at this
> point we'll be leaving it in though.

I'd say keep it for now.

> Andy, do you have any thoughts here?
>
> [1] http://wiki.debian.org/prism54

  Luis
