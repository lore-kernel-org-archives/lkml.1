Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYJVWgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYJVWgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYJVWf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:35:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:13100 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYJVWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D8rGXNeCP6JdfPeeN8cT32RIj43HJ3w7a57dphbTlNFdpKkGp4QBBCyVHpiU5i7PJz
         UaYopjnedqtMYGG6BkJEACTBfmcOuXPXyPULF4j4zCCvjfvVInMZZgVmkMrmkaNmzccX
         fP1y+FzagYgApG87ebu96XZmZ8Tbek+QLw3Mc=
Message-ID: <d9def9db0810221535xbe8e5aegef8b09b81206ee92@mail.gmail.com>
Date: Thu, 23 Oct 2008 00:35:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
In-Reply-To: <20081022222727.GA17599@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
	 <20081022222727.GA17599@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 12:27 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 23, 2008 at 12:24:31AM +0200, Markus Rechberger wrote:
>> On Thu, Oct 23, 2008 at 12:09 AM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, Oct 22, 2008 at 11:14:36PM +0200, Markus Rechberger wrote:
>> >>     em2880-dvb:
>> >>     * supporting the digital part of Empia based devices, which
>> >> includes ATSC, ISDB-T and DVB-T
>> >
>> > <snip>
>> >
>> > Doesn't this driver duplicate some of the existing devices we already
>> > support with the current in-kernel driver?  If so, why not just add the
>> > new device support to the existing driver instead of duplicating
>> > everything?
>> >
>> > This is going to cause a big problem for distros as they will not know
>> > which to enable, so they will probably just disable this one, which is
>> > what I don't think you want to have happen :(
>> >
>>
>> the current driver doesn't support most devices which are in there,
>
> Then why not just add new device support to the existing one?
>
>> also the alsa audio driver can easily crash the whole system. (It's my
>> code so I know what was wrong there).
>
> Why not send patches to fix it?
>

that's why I'm sending that request at the moment, development still goes on
on my side.

>> Very likely the best would be to replace the available driver with it
>> but I don't care, alot people use and have been using the driver from
>> mcentral.de for a long time, development has always been opensource
>> there too.
>
> Dropping existing code and replacing it entirely with a new base is not
> how Linux kernel development works for the most part.
>

the patch adds the driver from mcentral.de as alternative entry, not
the best way
but it currently supports almost all devices which have an entry in there.
2 or 3 entries definitely don't work yet due missing external drivers
which would
come in later.

> How about just sending patches in an incremental way, fixing problems in
> the current driver that you know about, and adding support for all of
> this goodness as well?  That's what all 2000+ other kernel developers
> do when they want to make changes like this.
>

I understand what you mean although too many things went from from the
beginning on
and people were in general not participating at discussions, it
slightly changed now but
the codebase evolved over time.

I'll be happy to do so for upcoming patches.

Markus
