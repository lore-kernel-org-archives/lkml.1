Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYKXQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYKXQlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYKXQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:41:08 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:36126 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYKXQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:41:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bGGDAn7fNnLGCGgS9GsImpWVNKD0ANiTmisHe5BOpd/SJscrKI16X5/ZW7o/lh9MkL
         fAXPlQ/3zniHsEy2lnJFG2IPkJG3vXIHaXQKMe7Tzi/a8h3kAoEvAOpi2XCJYvrmATk/
         GZooM24CgB2mI3AilMxZcy3godo2f+wRR2bPk=
Message-ID: <71cd59b00811240841j69451aafje5cbb5204dbff2e5@mail.gmail.com>
Date: Mon, 24 Nov 2008 17:41:03 +0100
From: "Corentin Chary" <corentin.chary@gmail.com>
To: "Thomas Renninger" <trenn@suse.de>
Subject: Re: [Acpi4asus-user] [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Cc: "Tom Hughes" <tom@compton.nu>, acpi4asus-user@lists.sourceforge.net,
       "Dave Jones" <davej@redhat.com>,
       "Cristiano Prisciandaro" <cristiano.p@solnet.ch>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
In-Reply-To: <200811241736.53067.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu>
	 <200811241613.25557.trenn@suse.de> <200811241736.53067.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 5:36 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Monday 24 November 2008 04:13:24 pm Thomas Renninger wrote:
>> On Monday 24 November 2008 10:38:58 am Tom Hughes wrote:
>> > Cristiano Prisciandaro wrote:
>> > > From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
>> > >
>> > > The bios of the eeepc 900 exposes an acpi method that allows clocking
>> > > the cpu to 630/900 MHz. This driver allows controlling the frequency
>> > > switch through the cpufreq subsystem.
>> >
>> > I should perhaps add at this point that I have an alternative patch
>> > based on Cristiano's code, which adds this cpufreq driver to the
>> > existing eeepc-laptop module rather than creating a separate module for
>> > it.
>> >
>> > Personally I'm quite happy with either solution so I'll leave it to you
>> > to decide what is the best way to go, but my patch is available if you
>> > want it.
>>
Why not just modprobe p4-clockmod ?
It already has all we want and works perfectly well.
