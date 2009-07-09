Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZGIVTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZGIVTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZGIVTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:19:00 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62528 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZGIVS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PFSu79z4LPLX0iuNHPlKpMeLTt0yq3B4dU2/fIIq6E0HMRIgk4zNW6mvSl4qD1r5Ht
         Z0P9HnK+TETKQ8UbZQas77+RPxibHV6s2ZDjCbxHc5nZE8gs0MwUIwn1MsPcY2HfR82S
         VGMA+ab57XZjf+i3FFJv1BNTLszpOSDs3uhnU=
MIME-Version: 1.0
In-Reply-To: <1247172044.3898.147.camel@mulgrave.site>
References: <20090630180300.GA9971@ldl.fc.hp.com> <4A4A5B01.9040200@kernel.org>
	 <20090703225708.GA30664@ldl.fc.hp.com> <4A4FADDC.30606@kernel.org>
	 <20090709185945.GG2613@ldl.fc.hp.com> <4A564263.5010305@kernel.org>
	 <4A564634.1020708@kernel.org> <4A564990.3060202@kernel.org>
	 <1247172044.3898.147.camel@mulgrave.site>
Date: Thu, 9 Jul 2009 14:12:36 -0700
Message-ID: <86802c440907091412n3157775ft4c025aab595923ad@mail.gmail.com>
Subject: Re: mptsas, msi and the dl585 g2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dann frazier <dannf@hp.com>, linux-scsi@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 1:40 PM, James
Bottomley<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2009-07-09 at 12:48 -0700, Yinghai Lu wrote:
>> [    4.333140]   PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
>> are all directed to one 8132 PCI-X bridge.
>>
>> the the IOAPIC for 9, 10, 11... falling that range...
>>
>> we need one better to allocate range for that pci-x bridge to aovide ioapic BAR allocated...
>>
>> anyway your BIOS sucks.
>
> It's a sad and very annoying fact of life that most BIOSs suck.  If they
> didn't suck, our bios handling code wouldn't be a nasty mess of
> exceptions, work arounds and quirks.
>
> Can we fix this so that both the DL585 and the opteron multi root stuff
> can work?  There's a large population of DL585's out there, so we can't
> release 2.6.32 like this ... and I'd rather not have to choose between
> breaking the DL585's and breaking the Sun Opterons.

sure. will send out one patch after get some sanity test here.

YH
