Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZKHTqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZKHTqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZKHTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:46:53 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36687 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZKHTqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:46:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ePCAF/CNFOVCZF5gampUIhDRvMsiSFCllnluyeqeEuMxeTyakfzWLDTeZLjaz6Vvny
         xPX+antwswY4um7tozoNmDy9fKLZkRKiKzxfZJ0ATEYsW1RfzOJC8RImBHYQp4118Dv8
         dCVXMI3Ko7JaZ7RTfJP9y2DfvMf2mOrS/tzmc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> 
	<4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com> 
	<20091108173708.GF1372@ucw.cz> <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com> 
	<20091108181016.GB32364@elf.ucw.cz> <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sun, 8 Nov 2009 20:46:37 +0100
Message-ID: <40101cc30911081146p6a72eb88m899dae0bae095f58@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 8:29 PM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Sun, 8 Nov 2009, Pavel Machek wrote:
>
>> On Sun 2009-11-08 18:40:06, Matteo Croce wrote:
>> > On Sun, Nov 8, 2009 at 6:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > > On Fri 2009-11-06 23:18:06, Matteo Croce wrote:
>> > >> On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > >> > On 11/06/2009 06:59 AM, Matteo Croce wrote:
>> > >> >> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
>> > >> >
>> > >> > MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.
>> > >> > I'm somewhat wondering about the general value of this patch; is i686
>> > >> > code really that much faster on Geode that it's worth it?
>> > >> >
>> > >> > ? ? ? ?-hpa
>> > >> >
>> > >> > --
>> > >> > H. Peter Anvin, Intel Open Source Technology Center
>> > >> > I work for Intel. ?I don't speak on their behalf.
>> > >> >
>> > >> >
>> > >>
>> > >> yes, I did some test like gzip, bzip2, lame etc and they give more or less
>> > >> the same results of dhrystone
>> > >>
>> > >> root@alix:/usr/src# CFLAGS='-march=i586' ./dry.c
>> > >> Microseconds for one run through Dhrystone:        1.4
>> > >> Dhrystones per Second:                          740741
>> > > ...
>> > >> root@alix:/usr/src# CFLAGS='-march=i686' ./dry.c
>> > >> Trying 5000000 runs through Dhrystone:
>> > >> Microseconds for one run through Dhrystone:        1.2
>> > >> Dhrystones per Second:                          841751
>> > >
>> > > Teach gcc that geodelx exists? No need to break kernel for that... and
>> > > you probably can gain even bigger gains.
>
> But no standard distribution will be made available in a geode special
> version - not enough machines in the marekt. So I think it is better to
> be able to use the i686 specific things they already support, like
> libc6-686 from debian for example.

That's exactly the patch point
