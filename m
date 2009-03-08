Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZCHQDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZCHQDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZCHQDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:03:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:11961 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZCHQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OGlCJlhTWuf/YB1FmYaZ8dK6PMLaychyVChXPdvWbWmSCQ317B+wTCqO4CabEON6RB
         rMj/l/zg/CFmFb9AE+Jaf0DT5k9iHYRDUgscPwPIgm1aBb7OrsmkRlaxSVOMYXDze5vX
         TYkTiS+Pv2PjMniZh4cLFEmlO3Yb+7YgHLbwE=
MIME-Version: 1.0
In-Reply-To: <20090307055404.GA549@kroah.com>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
	 <20090306175708.GD3099@kroah.com>
	 <3aaafc130903062143g4b7d6afel575781208319454e@mail.gmail.com>
	 <20090307055404.GA549@kroah.com>
Date: Sun, 8 Mar 2009 11:03:34 -0500
Message-ID: <3aaafc130903080903x4f1c49ealee40d3bf2b9e8764@mail.gmail.com>
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Christopher Brannon <cmbrannon@cox.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/09, Greg KH <greg@kroah.com> wrote:
> On Sat, Mar 07, 2009 at 12:43:43AM -0500, J.R. Mauro wrote:
>> On Fri, Mar 6, 2009 at 12:57 PM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Mar 03, 2009 at 09:06:46PM -0600, Christopher Brannon wrote:
>> >> Under Plan 9 from Bell Labs, one queries or sets the system clock by
>> >> reading or writing text strings to a special file named /dev/time.
>> >> I implemented such a facility for Linux.  A read of /dev/time produces
>> >> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
>> >> jiffies since boot, and jiffies per second.  Writing a decimal number
>> >> to
>> >> /dev/time sets the system clock to the given number of epoch seconds.
>> >> Anyone who is permitted to write to /dev/time may set the clock.
>> >> Granting this privilege becomes as easy as modifying groups and file
>> >> permissions.
>> >>
>> >> Signed-off-by: Christopher Brannon <cmbrannon@cox.net>
>> >
>> > I'm starting to see a few plan9 specific devices being proposed
>> > recently, with one making it into the staging tree recently (the p9auth
>> > interface).  Should we just start lumping them all together so to keep
>> > them in one place?  drivers/plan9/ ?
>>
>> That might be a good idea, assuming it doesn't start up a flamewar.
>
> I don't think if we keep it all in one place, it would.
>
>> The Glendix folks are working hard to get a lot of these device files
>> and filesystems implemented and it would be nice to see them have a
>> place to feel welcome.
>>
>> Would it be very involved to get a little sandbox for these things?
>
> drivers/plan9 looks like a nice place to me, any objections?
>

Sounds good to keep this all together, as more things come in. We
don't want to male a mess :-)
> thanks,
>
> greg k-h
>
