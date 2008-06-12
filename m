Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYFLWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYFLWQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYFLWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:16:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:54162 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYFLWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jKGxiLY6RC7/NxKff+FGhOkgfKurwXQLmT6oc3H5amsPRwPJo5Cz7TUltpqJlpFrIb
         m5rShdfroTFDAH3WataJR4Or8Itbk9rcMDNznRko2GBMDLkPbETg3KBy5PjcmrAnEPlI
         dWMwtqOjmhpF/NkbheGUg6Ts7258G+42KG/KM=
Message-ID: <86802c440806121516w3120716djffa68bef8033f4f4@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:16:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Cc: webmaster@dragonslave.de, "Daniel Exner" <dex@dragonslave.de>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080610224753.10ab33c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806051100.12885.dex@dragonslave.de>
	 <200806061930.29046.dex@dragonslave.de>
	 <20080606115024.387b5f80.akpm@linux-foundation.org>
	 <200806102229.10512.dex@dragonslave.de>
	 <20080610224753.10ab33c5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 10:47 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 10 Jun 2008 22:29:10 +0200 Daniel Exner <dex@dragonslave.de> wrote:
>
>>
>> Andrew Morton wrote:
>> > On Fri, 6 Jun 2008 19:30:28 +0200 Daniel Exner <dex@dragonslave.de> wrote:
>> > > Andrew Morton wrote:
>> > > > (cc linux-acpi)
>> > > >
>> > > > On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de>
>> wrote:
>> > > > > Hi!
>> > > > >
>> > > > > (Added myself to CC, because I'm not subscribed)
>> > > > >
>> > > > > with linux-next snapshot 20080604 my Laptop morphes into sitting duck
>> > > > > and I think this is due to this:
>> > > >
>> > > > I assume 2.6.26-rc5 is OK?
>> > >
>> > > Indeed.. just tried it with (nearly) the same config: no unable to locate
>> > > IOAPIC
>> > >
>> > > Will try todays next snapshot above -rc5 now.
>> >
>> > OK, thanks.
>> >
>> > It would be great if you could test 2.6.26-rc5 plus
>> > http://userweb.kernel.org/~akpm/git-acpi.patch.  That'll allow us to
>> > confirm that the regression is due to changes in the acpi tree.
>> Sorry for the delay.. real-life you know ;)
>>
>> I guess you'd expect me to confirm the behavior on rc5 with this patch aplied,
>> but .. well this Kernel works!
>>
>> So I think the regression is NOT in the acpi tree. Perhaps pci subsystem?
>
> There is behind-the-scenes finger-pointing going on ;)
>
> I don't think we know what caused this regression, sorry.
>
>> If I find time I'll try bisecting it..
>
> That would be fantastic, thanks.  Please don't let us merge this
> regression into 2.6.27.  We have a few weeks.

i'm confused. 2.6.26-rc5 is OK or not?

where is whole boot log for works kernel? also the config please.

YH
