Return-Path: <linux-kernel-owner+w=401wt.eu-S1946355AbXBQBBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946355AbXBQBBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946352AbXBQBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:01:53 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:39888 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946355AbXBQBBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:01:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M5OdvutzJlwumKUKremzoLoRYxaO/0jI/o5SQJC6Nps4WGFKmO+NZ6VQXgh2xZ7xvcIuEJQo9d1YbHTURxKmfL414+H5c9DKsolWXyXihn7K27LKAD4znC3ZL8V07dutlePoDhryv17NjKFYmn99/oiNnC3YE4zGmv0YVJxlPxw=  ;
X-YMail-OSG: SlhnrHIVM1mOJSCkqTrR8qPxda7G4YYViCPzJHlPkiHDLRl6O4BISSThcE1mUxjNpmhp0e9jX2CAoUDv6EbS99SgBGa2mUpmqJdF2nBGs7v4qmoHZEf6i7C4UZCPuvlPwFJl1d0Xoxz7PuU-
From: David Brownell <david-b@pacbell.net>
To: Len Brown <lenb@kernel.org>
Subject: Re: loosen dependancy on rtc cmos
Date: Fri, 16 Feb 2007 16:36:13 -0800
User-Agent: KMail/1.7.1
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214180915.GA6412@redhat.com> <200702152338.47151.lenb@kernel.org> <200702152112.08970.david-b@pacbell.net>
In-Reply-To: <200702152112.08970.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161636.13767.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 9:12 pm, David Brownell wrote:
> On Thursday 15 February 2007 8:38 pm, Len Brown wrote:
> 
> > So I've taken Andi's advice and checked in the patches below.
> 
> OK; that simplifies things for me, good!  I can discard that patch
> (broken by Andi's pcspkr change anyway), stop worring about whether
> most folk will even see that driver, and make time to look at the
> ACPI hooks for RTC wakeup, instead.  :)

Which, by the way, means that folk with pre-ACPI systems aren't
going to be able to use this driver until someone else provides
an updated patch creating an "rtc_cmos" platform device.

Or on the more modern end of things ... I suspect PCs using
Linux-BIOS won't do PNPACPI either, and they will also need
that platform device before using this driver.

What do the MiniMac systems do?  At one time I thought they
were ACPI-free.

- Dave
