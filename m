Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbXIUWM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbXIUWM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXIUWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:12:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:49506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbXIUWMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:12:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="317186550"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Message codes (Re: [Announce] Linux-tiny project revival)
Date: Fri, 21 Sep 2007 15:12:09 -0700
Message-ID: <5389061B65D50446B1783B97DFDB392D0715BCA1@orsmsx411.amr.corp.intel.com>
In-Reply-To: <200709211615.39898.rob@landley.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Message codes (Re: [Announce] Linux-tiny project revival)
thread-index: Acf8lJWi0yTwRTRrQWiyFHkz0OlCuAAA8e0Q
References: <46F1645D.9050406@am.sony.com> <E1IYWps-0006fQ-83@flower> <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com> <200709211615.39898.rob@landley.net>
From: "Gross, Mark" <mark.gross@intel.com>
To: "Rob Landley" <rob@landley.net>
Cc: "Oleg Verych" <olecom@flower.upol.cz>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       <linux-tiny@selenic.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Sep 2007 22:12:10.0539 (UTC) FILETIME=[74A497B0:01C7FC9C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Rob Landley [mailto:rob@landley.net]
>Sent: Friday, September 21, 2007 2:16 PM
>To: Gross, Mark
>Cc: Oleg Verych; Alexey Dobriyan; Michael Opdenacker; linux-
>tiny@selenic.com; CE Linux Developers List; linux kernel
>Subject: Re: Message codes (Re: [Announce] Linux-tiny project revival)
>
>On Friday 21 September 2007 9:18:40 am Gross, Mark wrote:
>> >-----Original Message-----
>> >From: Oleg Verych [mailto:olecom@flower.upol.cz]
>> >Sent: Thursday, September 20, 2007 5:58 PM
>> >To: Gross, Mark
>> >Cc: Rob Landley; Alexey Dobriyan; Michael Opdenacker; linux-
>> >tiny@selenic.com; CE Linux Developers List; linux kernel
>> >Subject: Message codes (Re: [Announce] Linux-tiny project revival)
>> >
>> >* Thu, 20 Sep 2007 15:15:47 -0700
>> >* X-MimeOLE: Produced By Microsoft Exchange V6.5
>> >[]
>> >
>> >>>*Shrug*.
>> >>>
>> >>>My problem is that switching off printk is the single biggest
bloat
>> >>
>> >> cutter
>> >>
>> >>>in
>> >>>the kernel, yet it makes the resulting system very hard to
support.
>>
>> It
>>
>> >>>combines a big upside with a big downside, and I'd like something
in
>> >>>between.
>> >>
>> >> What about getting even more hard core?
>> >>
>> >> Use compiler tricks to remove ALL the static printk string from
the
>> >> kernel and replace the printk with something that outputs an
decimal
>> >> index followed by tuples, of zero to N, hex-strings on a single
line.
>> >
>> >Not all, but critical info, that must exist in human-readable form
of
>> >course.
>>
>> I disagree.  For a production product the you want minimal
information
>> to reduce the communication bandwidth required between the remote
>> customer and the support organization.
>>
>> In fact there is a good argument that you don't what the remote
customer
>> to know enough to start guessing.
>
>Don't use Linux then.  Open source is a horrible fit for the way you
think.

I'll do what I like, thank you.  I'll continue to use Linux, I think
it's a fine fit for the way *I* think.

>
>I'm sympathetic to "shrink the binary size" arguments.  I'm not really
>sympathic to "keep the customer in the dark intentionally" arguments,
>whether
>the justification is "because they're stupid", "to increase dependency
on
>our
>support staff", or any other reason.

You are now talking religion at this point.  Do you have a technical or
even experience based point to make?  

I have experience that has shown that providing too much information in
a production product can is confusing, harmful and costly when dealing
with consumers.  Your opinions won't change that.

I proposed a mechanism for keeping all the printk data and saving space
buy doing some table based compressions that has the side effect of
making the syslog not human readable.  You proposed a mechanism for
no-oping out complete log-levels.   

Which way hides more from the user?  No-oping the log-levels is the
easier to implement.


>
>> >Seriously. When in the Windows there are only messages like:
>> >
>> >    "Error (Code:0x00002012)".
>>
>> Now it's been ~8 years since I did any serious windows work, but if I
>> recall correctly ALL THE FRICKING TIME!!! When was the last time
you've
>> seen a bug check on windows?  This is about all you get.
>
>I believe he was holding it up as a bad example, and definitely not
>something
>we want to emulate.

There is a time and place for many things.  Even error codes. 

--mgross
