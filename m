Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZCKTdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZCKTdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZCKTd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:33:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:35637 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZCKTdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R/Titt52thDfiRqpGMUvAM1Xgw6yFry9ygowO7iO+U2HTAAH5vcLmDmgJFwcio5lHr
         kTbSSp+vGHcToSexeB170NAMD9o36xL9CEnVAEm06yMA1cVc+buBG/0lyRZ288aviWF6
         J9xb4wrGEgE2/eUVnI7KFnB5R2yr0pNdvKR7c=
MIME-Version: 1.0
In-Reply-To: <20090311160208.GA21561@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
	 <1236514065.4205.9.camel@johannes.local>
	 <20090308223304.GB11513@kroah.com>
	 <1236583282.4205.71.camel@johannes.local>
	 <20090309194132.GB15011@kroah.com>
	 <1236633633.9658.23.camel@johannes.local>
	 <20090311050018.GB26202@kroah.com>
	 <1236762491.9658.85.camel@johannes.local>
	 <20090311160208.GA21561@kroah.com>
Date: Wed, 11 Mar 2009 15:33:21 -0400
Message-ID: <3aaafc130903111233n577cf501gc843982bd3882960@mail.gmail.com>
Subject: Re: Staging, place holder for better company/community development 
	model
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:02 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Mar 11, 2009 at 10:08:11AM +0100, Johannes Berg wrote:
>> On Tue, 2009-03-10 at 22:00 -0700, Greg KH wrote:
>>
>> > > Except it doesn't work for most of the wireless drivers you've sucked in
>> > > without asking any wireless developers whether that makes any sense or
>> > > not.

That doesn't mean staging is useless, nor does it imply that no one
wants the drivers or wants to work on them. A lot of the drivers in
staging are getting the attention they need, it's not like things are
just getting dropped in there and abandoned. Staging has only been
around for a few months now, so it's really too early to say whether
it will work or not... and hey, maybe it won't work out, but I think
it has a lot of promise, and has already had real results. It's just
lacking momentum and autonomy because it's a new thing.

It looks like the solution to your particular problem would be a
mailing list devoted to staging. I know I'd like to see one just
because I miss a lot of patches that go in until I pull from Greg, and
it would be nice for the discussion to be centralized. You could steer
clear of such a list, and we could work on all the drivers until we
think they're ready, and only then pass it by the relevant
maintainers.

Greg, does a special list sound like a good idea? The driverdev list
seems really low-traffic, maybe we could use that?

>> >
>> > Any specific examples?
>>
>> wlan-ng is the largest example, it's a load of crap, much of it being a
>> driver for hardware we already have drivers for, and the remaining
>> hardware being mostly unavailable these days. The driver served it's
>> purpose at a time, but the authors had years and years of time to bring
>> it in and never bothered. It needs to be incorporated into a
>> rearchitectured orinoco driver, or so.
>
> So you are objecting to the fact that some people are spending their own
> time cleaning up this driver, which is only enabled for the devices that
> are not supported by any other Linux wireless driver, because the
> original developers never took the time to do the cleaning up
> themselves?
>
> Why do you want to tell others how to spend their time, when they are
> trying to get devices to work properly with Linux that otherwise would
> not?
>
>> I also remember objecting to rt2860/rt2870, and the only good thing that
>> has come out of adding those is a spatch that might otherwise not have
>> been applied to those drivers. Afaict, no new people have helped with
>> rt2800, the rt2x00 based driver for this hardware, because they've come
>> in contact with rt2860/rt2870.
>
> So you think that the staging tree is pulling away developer help for
> the other "proper" kernel drivers?
>
>> I don't remember any discussion about rtl8187se either.
>
> Was there supposed to be some?
>
> I sure discussed it, as I have hardware here that needs it, yet trying
> to get it working in the in-kernel driver was pretty much impossible.
> So I added the staging driver and lots of users are now happy that Linux
> works on their hardware and they don't have to go download some random
> driver to get it to work.
>
>> All of those bring their own 802.11 stack, and changing to the Linux one
>> will /necessarily/ require an entire rewrite of the drivers because the
>> stacks operate /completely/ differently.
>
> I agree, and don't see how this is a problem.
>
>> Even the clean, in-kernel bcm43xx driver was rewritten to b43 for
>> mac80211, and rtl8187se ships the old ieee80211_softmac code that I
>> and a few others wrote...
>
> Yes, these drivers are going to take a lot of work to get into "proper"
> mergable shape.  But that's the whole point of the staging tree!  To do
> this work, in the kernel, with lots of other developers, all the while
> letting real people use their hardware with Linux today.

And it /is/ working to attract people both to help and to encourage
people to get their drivers in. Staging would be really nice for
bringing in new drivers so that we can prevent things like wonky 80211
stacks being used and not ported simply because outside driver project
don't have the time and manpower for it. It's entirely too early to
see some of the benefits that staging hasn't yet brought to the table
that I think it will. The two problems I see are that a lot of people
don't know about it yet, and we just obviously need to sort out the
logistics to avoid impacting people who don't want to be impacted.

Hopefully making staging a little more autonomous with its own mailing
list would help; people who want to pitch in know where to find it,
people who don't want to look at code until its ready don't even have
to know it exists. In the meantime, we can get old, crappy drivers
into shape (eventually), and prevent new drivers from going down the
wrong path or dying out. And in the meantime, people don't have to
scrounge for support for their devices.

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
