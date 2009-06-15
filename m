Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZFOXlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZFOXlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZFOXlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:41:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:61999 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZFOXlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SBoXUbVjmyc7H0Sm0okyXatvEKOMgL9nQqvBKwmcZqnwdXbhjZV7gHWhKbjVDkPa3X
         jEtbKhna/vw7DKlZirRp97Ju+h+lL5BhE40nTNcpNL0KCv03PiWb/u490z6bB1y9BsKG
         KUWwUMTc8ULb/WntEC5U87qM2wLZBBUJxCaJM=
MIME-Version: 1.0
In-Reply-To: <20090615223941.GA8974@huya.quicinc.com>
References: <4A3175AC.9070100@bluewatersys.com>
	 <4A31AECA.6070303@bluewatersys.com>
	 <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
	 <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
	 <20090612103521.GD18682@elf.ucw.cz>
	 <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
	 <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com>
	 <20090615162150.GC6842@huya.quicinc.com>
	 <17b28da20906151525q1d8f10daj734faacf5dafda12@mail.gmail.com>
	 <20090615223941.GA8974@huya.quicinc.com>
Date: Tue, 16 Jun 2009 09:41:14 +1000
X-Google-Sender-Auth: 2c6b76e710042728
Message-ID: <17b28da20906151641q352fd44fme0e7ddf347cf0b93@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Ben Leslie <benno@benno.id.au>
To: Ben Leslie <benno@benno.id.au>, Brian Swetland <swetland@google.com>,
       Pavel Machek <pavel@ucw.cz>, Nicolas Pitre <nico@cam.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 8:39 AM, <davidb@quicinc.com> wrote:
> On Mon, Jun 15, 2009 at 03:25:35PM -0700, Ben Leslie wrote:
>
>> > The Android busybox
>> > <http://benno.id.au/blog/2007/11/14/android-busybox> mostly
>> > works.  The poster doesn't seem to provide source, even though
>> > busybox requires modification to build for Android (although not
>> > much).
>>
>> I didn't need to change anything; I just compiled busybox; No changes
>> required. (Note: It is a static binary that includes glibc).
>
> I wonder if it's changed since you built it, then.  I had to hack
> up a few paths since the Android environment doesn't put things
> in normal places.

Possibly, it was quite some time ago! And I have an imperfect memory.

I'm fairly sure I would have put up any patches if I did need to change
things; that is what I normally do. I'm trying to dig the source tree out of
my archive just to verify.

I would say that the binary there is pretty much completely redundant now.
Any new busybox 'for android' should probably build against the Android
C library, with the Android version of gcc etc. My contribution was done
before any of the Android source was available, and was compiled with
the codesourcery gcc compiler.

(Note: Strictly speaking I really should have the source code for it
irrespective of if I made any changes to the source code; rectifying
that now.)

Cheers,

Benno
