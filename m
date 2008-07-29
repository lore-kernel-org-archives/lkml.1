Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYG2AOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYG2AOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYG2AOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:14:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:6563 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYG2AOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fdae6r+xJRlPhG43Ip7Ygao6IceFOZ2vZetovjtacAQ49WLJONBdPGPpvAJLgNiwrB
         OzDEpSi7WZDwO5S6MERyxBDYjPi7OER4IpipYd9pWm4gCKZABNtGIqEE2/c+5Li83eMj
         p8fboPDvVa9qRLxUUcG4tvlz6kUUsKSIh4LC8=
Message-ID: <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com>
Date: Mon, 28 Jul 2008 20:14:22 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "James Morris" <jmorris@namei.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Dave Jones" <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080728234131.GD28055@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488DFD97.7080802@simon.arlott.org.uk>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com>
	 <20080728141414.d7e5def2.randy.dunlap@oracle.com>
	 <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>
	 <20080728234131.GD28055@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Jul 29, 2008 at 08:01:09AM +1000, James Morris wrote:
>  > On Mon, 28 Jul 2008, Randy Dunlap wrote:
>  >
>  > > It would be Good if we could give more value to Reviewed-by: tag lines also...
>  > >
>  > > IOW, we "need" to do this.  :)
>  >
>  > Also, Tested-by:, to encourage and recognize people who may not be
>  > confident in reviewing code to at least test it, which is immensely
>  > useful if done thoughtfully.
>  >
>  >   "Measuring programming progress by lines of code is like measuring
>  >    aircraft building progress by weight."
>  >
>  > If you know who said this, award yourself a cookie :-)
>  >
>
> Or just filter on "-by:", which seems to get anything relevant, including
>  people that shamelessly make up their own tags. In order for something to
>  be converted from a Cc: to a *-by: requires manual effort at least, which
>  ought to be sufficient for recognition.
>
>  If someone was really bored they could probably make a table of tags with
>  various points to try and balance things slightly more objectively.
>  Though it seems we now at least have totally different metrics on LWN,
>  for the kernel summit selection process, and Jon's new script. ;-)
>
>  Trying to map all of the names seems pretty pointless though, most
>  regular contributors contribute in a fairly consistent and sane manner,
>  with the odd mismatch or typo here or there. It might make sense for
>  anyone where there's a significant difference, but those are going to be
>  corner cases.

12% of the name/email pairs are messed up. It's not all simple typos.
There is significant mangling of non ASCII charsets by people's tools
in the maintainer's chain of processing. Half of the time I don't
believe what the author is submitting is what is ending up in the log
due to mangling. It's a larger source of noise than typos.

All of these variations on email names are in the log. Humans can
identify these problems, it is much harder for a machine.

For example, where are these backslashes coming from?
Auke-Jan H Kok <auke-jan.h.kok@intel.com>
Auke-Jan H Kok <auke\-jan.h.kok@intel.com>
Auke-Jan H Kok <auke\\-jan.h.kok@intel.com>
Auke-Jan H Kok <auke\\\-jan.h.kok@intel.com>
Auke-Jan H Kok <sofar@foo-projects.org>

Are the tools case sensitive or insensitive on email addresses? Some
are are some aren't, so I need these cases...
Al Viro <viro@zeniv.linux.org.uk>
Al Viro <viro@zenIV.linux.org.uk>
Al Viro <viro@ZenIV.linux.org.uk>

Another problem is internal machine names...
David S. Miller <davem@sunset.davemloft.net>
David S. Miller <davem@davemloft.net>
David S. Miller <davem@huronp11.davemloft.net>
David S. Miller <davem@hutch.davemloft.net>
David S. Miller <davem@bnsf.davemloft.net>
David S. Miller <davem@t1000.davemloft.net>
David S. Miller <davem@ultra5.davemloft.net>
David S. Miller <davem@goma.davemloft.net>

Or varying the email name...
Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Alexey Starikovskiy <alexey_y_starikovskiy@linux.intel.com>
Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>

Why do these all end in (none)?
Craig Hughes <craig@com.rmk.(none)>
Dave Neuer <dneuer@org.rmk.(none)>
David Brownell <david-b@net.rmk.(none)>
David Woodhouse <dwmw2@org.rmk.(none)>
Deepak Saxena <dsaxena@net.rmk.(none)>
Enrico Scholz <enrico.scholz@de.rmk.(none)>

-- 
Jon Smirl
jonsmirl@gmail.com
