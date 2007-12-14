Return-Path: <linux-kernel-owner+w=401wt.eu-S1763852AbXLNVXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbXLNVXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXLNVXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:23:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:4869 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbXLNVXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:23:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=si1YtzK0C2xNhhHQTsT31XDYAM2Tp8oXnU2fNxnzhe4ZXXfrNJsfqDVj0JGscyvT1ZCT0gkHTb2ZkQ67mtogv+6NAMzycvRYYBPKHOV9CoExvPGUIecaNAkDYE0aJCrw/4VUyHvjXfCrQtJ9tz3QzdHsnGBxwA0BZk/cwgxesY4=
Message-ID: <8bd0f97a0712141323k7aae718ag4d0fd8a8f13d933f@mail.gmail.com>
Date: Fri, 14 Dec 2007 16:23:12 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: Working upstream toolchain for avr32?
Cc: "Adrian Bunk" <bunk@kernel.org>, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071214205542.GO3851@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213195617.GF21616@stusta.de>
	 <20071214200318.GM3851@pengutronix.de>
	 <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com>
	 <20071214202829.GN3851@pengutronix.de>
	 <8bd0f97a0712141235h48c3062cl139e4c2883a815a9@mail.gmail.com>
	 <20071214205542.GO3851@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 3:55 PM, Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> On Fri, Dec 14, 2007 at 03:35:36PM -0500, Mike Frysinger wrote:
> > > Upstream plus a well defined patch stack with well documented patches
> > > would definitely be preferred here.
>
> Well, tell me that it is wrong, but isn't it common community
> methodology to have rebasable things like patch stacks or git trees
> against mainline instead of disconnected vendor trees?

it depends on the community.  both methods are quite common.

> > as you've been told in the past, the things are documented. go read
> > the ChangeLog.bfin file.
>
> You didn't explain how for example your trunk [1] is related to mainline
> [2].

nano `find -name ChangeLog.bfin`

read the ChangeLog and the associated commit.  this is exactly the
same way gcc works.  you want to know what changed for ChangeLog entry
$foo, you look at the commit surrounding it.

> > > Ah, that sounds pretty good! At the moment we still need three different
> > > toolchains to build u-boot, the kernel
> >
> > maybe, if you're using different version of u-boot and the kernel.
> > but that isnt a good idea anyways.
>
> We use mainline linux and u-boot-v2, which is surely not what ADI
> supplies officially to their random commercial customers. Nevertheless,
> it is the way community technology works elsewhere.

i dont know what "u-boot-v2" is, but if you're referring to mainline
u-boot, then it too is not in a usable state.  it isnt just random
commercial customers as we support anyone using a Blackfin (students,
hobbyists, whoever).  but only if they're using the same source base
we've tested.  once we finish moving things to mainline, that will
become our source base.  until then, it is not supportable.

> > > and the icebear tools, which is not very satisfying.
> >
> > there's nothing we can do about this and you're complaining to the
> > wrong people. icebear is a third party binary-only tool.
>
> Hmm, the sources are here: http://www.section5.ch/dsp/icebear/bfloader-1.2.tgz

*some* of the sources.  icebear requires usage of binary blobs in
there to communicate with their USB JTAG.

> Do you have a good hint for a better low level debug tool? For all other
> processors like ARM, PowerPC and ColdFire we use a BDI2000, but it seems
> not to be available for blackfin.

there are parallel port jtags available for cheap as well as an
ethernet solution.  links can be found in the Blackfin docs wiki.

> > if you dont like the way the third party does things, complain to
> > the third party. or dont buy their product.
>
> Thanks for the constructive comments.

they are constructive and quite in the open source spirit.  if you
dont like dealing with binary blobs, then dont complain to people who
can literally do noting about it, do something yourself about it.  put
your money where your mouth is.

> > we are upstream and we've given you blessed toolchains.
>
> "Trust us, we are $BIG_VENDOR" is not the way these things are usually
> done. Sorry, I don't buy this. Chip vendors just too often lose interest
> in supporting their users once they have moved to the next generations
> of chips or whatever.

<insert generalities about "big corporations here" and assume everyone
is the same.  it's easier when making assumptions that way!>

> Can you explain why bfin should not have gcc.gnu.org as it's upstream?

as you've been told multiple times, that is where we are heading.
asking the same question multiple times but expecting a different
response is the definition of madness is it not ?
-mike
