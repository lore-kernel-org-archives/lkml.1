Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXDHNY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXDHNY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 09:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXDHNY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 09:24:59 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:15821 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXDHNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 09:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NvjmfXZkvklmCLRqCThREBDaz04O1CBpmeXhIGc9RilIhts61pG19Vud7adcOwb5mgMvgdS4DqdLW7ONPKuZHq3zkVBheMOguPWMdDt613q4uMO5DG8TRfJA/tsVBEgUsPBPDOogPs9aArOr2VU9Zb4xE6NLwEWQQJKI5VU2mTc=
Message-ID: <7b69d1470704080624i326656dci7ecbee154f126e81@mail.gmail.com>
Date: Sun, 8 Apr 2007 08:24:57 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Cc: "David Brownell" <david-b@pacbell.net>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Tony Lindgren" <tony@atomide.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <dbrownell@users.sourceforge.net>
In-Reply-To: <46169968.2050006@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11757099691323-git-send-email-tony@atomide.com>
	 <200704051119.11944.david-b@pacbell.net>
	 <Pine.LNX.4.61.0704052232540.6042@yvahk01.tjqt.qr>
	 <200704061029.55710.david-b@pacbell.net>
	 <46169968.2050006@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> David Brownell wrote:
> [...]
> >>> 1   if (To control chain reactions, your odds
> >>> 2                   Improve if you've got cadmium rods) {
> >>> 3           In your fission reactor
> >>> 4           Their lack is a factor
> >>> 5   }
> >>> 6   In screams of "A meltdown! Ye gods!"
> >>>
> >>> Now, the former makes it hard to tell what's condition vs consequent.
> >>> (Or whatever the correct technical term is in cases like these.)
> >> My fu dictates that continuation lines (line 2 in this example)
> >> should have more indent than line 1,
> >
> > Yes.  Where "indent" is measured -- always!! -- in tabs.
> > Documentation/Coding style is quite explicit on that point:
> >
> >       Outside of comments, documentation and except in Kconfig,
> >       spaces are never used for indentation ...
>
> I usually indent this way if expressions exceed the 80 columns limit:
>
>         if (foo___________ &&
>             bar___________) {
>                 doit;
>         }
---

I disagree vigorously - the operators should be at the front of the
line, so that the logical structure is clear. [The editor I'm doing
this in won't let me use tabs, so I won't even try to do an
example...]

As other people have noted in this thread, it's a rule that would earn
Emerson's "foolish consistency" label, if it actually were followed
slavishly. In fact, the kernel looks like people tend to do the right
thing, rather than always following the letter of the law.

Tab indenting is a good rule for the general case, but there are also
places (and breaking long conditionals is at the top of the list)
where it's much more important to express the structure, and the
structure has too many logical sub-points to line up with the
relatively small number of 8-space tabs available in an 80-character
line.

Of course, expressions too complicated to fit the rule are also a sign
that you might want to simplify things...

scott
