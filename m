Return-Path: <linux-kernel-owner+w=401wt.eu-S1765334AbXGKRH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765334AbXGKRH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXGKRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:07:16 -0400
Received: from phantom.scannet.dk ([195.69.129.60]:1194 "EHLO
	phantom.scannet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXGKRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:07:14 -0400
X-Greylist: delayed 1178 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 13:07:14 EDT
Message-ID: <469509BB.9050405@hacker.dk>
Date: Wed, 11 Jul 2007 18:47:55 +0200
From: Dan Faerch <dan@hacker.dk>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Deepak Saxena <dsaxena@plexity.net>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ata and netdev (was Re: -mm merge plans for 2.6.23)
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<4693C4F8.40903@garzik.org> <20070710112458.e9dbb55e.akpm@linux-foundation.org>
In-Reply-To: <20070710112458.e9dbb55e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> drivers-net-ns83820c-add-paramter-to-disable-auto.patch:
>
> See comments in changelog: ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/drivers-net-ns83820c-add-paramter-to-disable-auto.patch
>
> Dan, Ben: is there any prospect of progress here?
Mmm.. Ben had 2 comments last year:

In regards to the ethtool stuff i coded:

> This part is good, although doing something for copper cards needs doing, 

I know very little about hardware and only own the fiber version of this 
card. Even if i tried to make code for the copper version, it would 
probably blow it up the phy and set the switches on fire ;).

And in regards to the '"disable_autoneg" module argument':

> This is the part I disagree with.  Are you sure it isn't a bug in the 
> link autonegotiation state machine for fibre cards?  It should be defaulting 
> to 1Gbit/full duplex if no autonegotiation is happening, and if it isn't 
> then that should be fixed instead of papering over things with a config 
> option.

This is pretty much Russian to me. 
I wouldnt know where to find the "link-autonegotiation-state-machine-for-fibre-cards" or know what to do with it anyway :).

The "disable_autoneg" is a convenient feature (for me and the other guy who made the same patch last year) and i consider it a harmless feature in every way.
It is simply an 'if'-statement, that skips the "start autoneg" function upon load.
We can simply remove the feature entirely if it is deemed undesirable.



So in conclusion:
- I vote "use the patch as-is", but im fine with it being changed. 
- If it needs support for copper, someone else has to code it.


Regards
- Dan

