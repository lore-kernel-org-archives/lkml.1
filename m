Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbZCQIbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbZCQIbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762979AbZCQIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:30:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763030AbZCQIaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wla5Z1jLnCosAFRq6sYUPEPPKPok7/bD7pyqNHCeGc5JEePDo2Ik1Xc6tbqJ4FSXXE
         vjS5BC1BxHbjx642T7RA+gbDT7PyHLNFnUnkbyKlsmKJKnYrHpZMLD3l0FJzENojwoLW
         KgM1knMVuFTD8lDZQwEG4Fy7F5bDyBwiB9GKE=
MIME-Version: 1.0
In-Reply-To: <20090316082952.GA1963@elf.ucw.cz>
References: <1227454026.7262.59.camel@localhost> <20081123180409.GB7731@ucw.cz>
	 <20081202161520.GA18252@srcf.ucam.org> <20081202201442.GA1504@ucw.cz>
	 <alpine.LFD.2.00.0903160020250.30317@localhost.localdomain>
	 <20090316082952.GA1963@elf.ucw.cz>
Date: Tue, 17 Mar 2009 09:30:48 +0100
Message-ID: <b637ec0b0903170130n68754d9eu504ad6b6f4330d89@mail.gmail.com>
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, tom@compton.nu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I see that this thread has resumed after three months of being idle.
Is there a chance that either Cristiano's or Tom's version can be included?

By the way, I currently run my eeepc 900 with cpufreq disabled.
Looking at the patch, with Tom's mods to eeepc_laptop I could do the
same, am I right? I see only an include for cpufreq.h and nothing
else.

Thanks,
Fabio



On Mon, Mar 16, 2009 at 9:29 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2009-03-16 00:24:18, Len Brown wrote:
>>
>> On Tue, 2 Dec 2008, Pavel Machek wrote:
>>
>> > On Tue 2008-12-02 16:15:21, Matthew Garrett wrote:
>> > > On Sun, Nov 23, 2008 at 07:04:09PM +0100, Pavel Machek wrote:
>> > >
>> > > > Is this really needed? Could we simply talk to the cpu directly,
>> > > > without help of ACPI?
>> > >
>> > > No. The ACPI write ends up talking to the embedded controller and some
>> > > io ports.
>> >
>> > Oops... I always knew that eee-s are broken by design (reporting
>> > battery percent as mWh, etc...) but I did not realize how bad it
>> > is. (ACPI has perfectly standard cpu frequency scaling interface, even
>> > if it is not used too often these days....)
>>
>> Huh?
>>
>> What cpufreq driver is deployed more broadly than acpi-cpufreq?
>> AFAIK, Linux uses it on nearly every ACPI compliant Intel-based
>> system that has frequency scaling.
>
> Problem seems to be that eee uses custom ACPI methods
> (switch_to_fast_clock(0/1)-like), not anything acpi-cpufreq could
> drive... Broken by design :-(.
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
