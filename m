Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZCCPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZCCPVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZCCPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:21:06 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58233 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZCCPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:21:04 -0500
Message-ID: <49AD4A9C.2080209@s5r6.in-berlin.de>
Date: Tue, 03 Mar 2009 16:19:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: david@lang.hm, Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>	 <49ACC6B0.409@garzik.org>	 <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>	 <20090303072637.GB4440@kroah.com>	 <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>	 <alpine.DEB.1.10.0903022340060.14744@asgard.lang.hm> <43e72e890903022357p7594cf98gd7c1061a78f8828a@mail.gmail.com>
In-Reply-To: <43e72e890903022357p7594cf98gd7c1061a78f8828a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Mon, Mar 2, 2009 at 11:42 PM,  <david@lang.hm> wrote:
>> - Show quoted text -
>> On Mon, 2 Mar 2009, Luis R. Rodriguez wrote:
>>> OK small silly example is convincing distributions it may be a good
>>> idea to carry linux-next kernel packages as options to users to
>>> hopefully down the road reduce the delta between what they carry and
>>> what is actually upstream.
>>
>> linux-next is a testing tree for developers, it changes day to day, doesn't
>> contain all relavent changes, and is definantly _not_ something that distros
>> should be pushing to users.
> 
> Why not? Just as people may want to get bleeding edge wireless I don't
> see why a user may not want to simply get bleeding edge wireless and
> bleeding edge audio, and video.

They want wireless to work and audio to not break.

> The latest RC series helps but lets
> face it there are also a lot of good stuff queued for the -next
> releases as well. The way I'm seeing this is if a user has no support
> for a device on their system it should look something like this:
> 
> Distribution kernel -->
>   Distribution next stable kernel release (2.6.27 --> 2.6.28) -->
>     Distribution RC kernel (if one is available) | kernel.org RC kernel -->
>       Development tree kernel for a specific device -->
>         Staging
> 
> If the have multiple devices which are not yet supported by the latest
> RC kernel but on -next then you have little options but I think a
> concrete one should exist and it does.

Testers for linux-next are certainly welcome, but these testers need to
understand what the actual topic of linux-next is.

It is an integration-testing tree (for what is anticipated to be part of
Linus' next merge window).  Integration testing is for the purpose of
detecting + fixing (or avoiding) problems due to interactions between
subsystems, or between infrastructure code to peripheral code.

Therefore I agree with David that linux-next is somewhat too special for
general consumption.

Before integration testing, we test subsystem developments in a more
targeted fashion in our myriad of subsystem development trees.  (These
trees host special branches from which linux-next is created almost
daily in a more or less automated fashion.)

Of course if a distributor wanted to package linux-next, why not.  The
nature of -next would call for several of such package releases per week
though.
-- 
Stefan Richter
-=====-==--= --== ---==
http://arcgraph.de/sr/
