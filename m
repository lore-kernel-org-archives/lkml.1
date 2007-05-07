Return-Path: <linux-kernel-owner+w=401wt.eu-S967177AbXEGWts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967177AbXEGWts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967130AbXEGWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:49:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45824 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967014AbXEGWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:49:44 -0400
Message-ID: <463FADB7.3080900@oracle.com>
Date: Mon, 07 May 2007 15:52:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Roman Zippel <zippel@linux-m68k.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
References: <m3abwhcy74.fsf@maximus.localdomain>	 <m3r6psc0ee.fsf@maximus.localdomain>	 <Pine.LNX.4.64.0705071509290.1479@scrub.home>	 <463F27CE.2040008@garzik.org>	 <Pine.LNX.4.64.0705071538060.1479@scrub.home>	 <m3lkg0a88y.fsf@maximus.localdomain>	 <Pine.LNX.4.64.0705071901020.1479@scrub.home>	 <a781481a0705071115v5bce9382q166b9c0e0c52c6ef@mail.gmail.com>	 <463F8CB4.3040603@garzik.org>	 <20070507135052.cc7e74ca.randy.dunlap@oracle.com> <a781481a0705071539o75b256a4p91228a4f8c4a63a7@mail.gmail.com>
In-Reply-To: <a781481a0705071539o75b256a4p91228a4f8c4a63a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/8/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Mon, 07 May 2007 16:31:48 -0400 Jeff Garzik wrote:
>>
>> > Satyam Sharma wrote:
>> > > Yes, mixing select and depends is a recipe for build disasters. Call
>> > > me a rabid fanatic, but I would in fact go as far as to say that this
>> > > whole "select" thing in the Kconfig process is one big BUG, and not a
>> > > feature. People are lazy by nature and would rather just "select" a
>> > > dependency for their config option than burden users with several
>> > > "depends".
>> >
>> > Tough, the kernel community has voted against you.
>>
>> Andrew (usually) implores people not to use "select" and I agree
>> with him.
>>
>> > It makes far more sense to include a driver during kernel 
>> configuration,
>> > and have that driver pull in its libraries via 'select'.  The lame
>> > alternative requires developers to know which libraries they need 
>> BEFORE
>> > picking their drivers, which is backwards and requires legwork on the
>> > part of the kernel developer.
>>
>> Developers?  If you had said "users," I might agree, but IMO it's
>> OK (or even Good) for developers to know what libraries their code
>> uses/requires.  Yes, that's a good thing.
> 
> You're absolutely right, but to give Jeff the benefit of the doubt I'm
> sure he _meant_ "users" there although he said "developers". Stating
> the obvious, the developer _has_ to know what stuff his code uses
> anyway, otherwise what does he "select"s or "depends" his config
> option on.
> 
> As for users, we _can_ avoid pitfalls by building a complete
> dependency tree and just selecting _everything_ that we require for a
> particular config option to be selected, but some users could
> conceivably prefer only being _told_ about what else they need to
> successfully pick a config option (than everything just getting in
> behind their backs). Actually (correct me if I'm wrong), this is not
> presently possible: an option is not visible unless dependencies are
> already picked. Just a suggestion, though.

That's correct for menuconfig.  For xconfig, there are GUI options to
	Show Name
	Show Range
	Show Data
	Show All Options
	Show Debug Info

I often have all of them enabled.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
