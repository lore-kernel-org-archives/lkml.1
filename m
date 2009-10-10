Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZJJKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZJJKjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZJJKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 06:39:18 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46486 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZJJKjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 06:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kCjJCDcNNSsZZY7A4wLtEOd/3Gs6gJVom4nWlye4ymv5SIjZyqwYXJ0TLrRzQvNlKo
         8gwhyxbmhIRCw2wZe3tGbqTUmp6M6eCnwxKETwMyFNwwhVCSv0emDGqHtika2FoHR7eo
         97/HLOmQq6Fkt3AnEIaHH2ojdtfGiwN3aN6kI=
MIME-Version: 1.0
In-Reply-To: <20091009143327.783b33c3.akpm@linux-foundation.org>
References: <20091007185112.GJ7899@atomide.com>
	 <20091008214140.GJ7417@atomide.com>
	 <94a0d4530910081513w1a919dc2s50eca41966a2261d@mail.gmail.com>
	 <94a0d4530910081520t66ce7567xe142979a35b1245@mail.gmail.com>
	 <20091008232603.GB25892@atomide.com>
	 <94a0d4530910090508o1e3d19cew881d2eb348199674@mail.gmail.com>
	 <20091009144840.GA9561@suse.de>
	 <94a0d4530910091029p12f8c28fve91e95db533e78e5@mail.gmail.com>
	 <20091009192642.GB32084@suse.de>
	 <20091009143327.783b33c3.akpm@linux-foundation.org>
Date: Sat, 10 Oct 2009 13:38:39 +0300
Message-ID: <94a0d4530910100338s6fb32d0dwb898d31053a423f5@mail.gmail.com>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 12:33 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 9 Oct 2009 12:26:42 -0700
> Greg KH <gregkh@suse.de> wrote:
>
>> > >
>> > > What kind of issues? __Why would I be interested, where is the problem?
>> >
>> > The obvious-brain-dead-duh kind of issues, like this one.
>> >
>> > The problem is that OMAP devices (like beagleboard) are not booting
>> > correctly right now because of a wrong merge. It has been identified,
>> > tested, and acked, but nobody has picked it up for a pull request, so
>> > it's not clear it will be on -rc4.
>>
>> Has the patches been sent from the maintainer to Linus?
>>
>> Who is the maintainer?  Who normally sends this stuff?
>>
>> > To me it's not clear who should push the patch, it seems it doesn't
>> > belong on linux-omap, so Tony is pushing it through linux-mmc, which I
>> > don't think is the right place. They should be handling mmc-related
>> > issues, not obvious breakage.
>>
>> Well, mmc related breakage is fine to handle :)
>>
>> > In order to keep the engines oiled I think there must be a process to
>> > flag obvious generic breakage so it's immediately picked; maybe an
>> > 'obvious-fixes' tree, or a 'simple-fixes' that has 'trivial',
>> > 'includecheck', and similar, or maybe nothing needs to be done. Up to
>> > you to decide.
>>
>> Andrew usually sends stuff like this at times.
>
> yeah, when in doubt, send it to me.  When not in doubt send it to me
> anyway ;)
>
> I'll take care of bugging the appropriate maintainer or merging it directly.

Ah, that's exactly what I wanted to know, thanks :)

-- 
Felipe Contreras
