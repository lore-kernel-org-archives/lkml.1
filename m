Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbXBDUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbXBDUyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXBDUyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:54:32 -0500
Received: from mail.tmr.com ([64.65.253.246]:33694 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbXBDUyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:54:32 -0500
Message-ID: <45C64807.9030108@tmr.com>
Date: Sun, 04 Feb 2007 15:54:31 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: David Hollis <dhollis@davehollis.com>, Jeff Garzik <jeff@garzik.org>,
       Trent Waddington <trent.waddington@gmail.com>,
       Dave Airlie <airlied@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com> <3d57814d0701301424m67d22cdbg7afc0a1dab29c152@mail.gmail.com> <45BFC99A.8040805@garzik.org> <1170250461.12914.33.camel@dhollis-lnx.sunera.com> <Pine.LNX.4.61.0701311853390.13737@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701311853390.13737@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 31 2007 08:34, David Hollis wrote:
>> Conversely, I've seen many cases of drivers that are developed by the
>> community, but kept out-of-kernel forever due to various reasons.  Some
>> of them are due to the code quality and the developers not accepting the
>> feedback to get the drivers into shape to be 'kernel worthy', sometimes
>> it seems to be a lack of interest from the developers to merge upstream.
>> Maybe because they think they would lose control or something?
> 
> Putting the "codingstyle" control aside, often it's because things look
> too hackish. Take ipt_ROUTE as an example. It won't get included, since
> the "proper" way to do it would be using MARK and iproute2. But many users
> don't get that [no criticism here], because ipt_ROUTE is so much easier.
> (Probably because iproute2 and other netlink-using tools, like tc, lack
> thorough documentation.)
> 
Doing it by MARK a tables and rules is an ugly method, and like anything 
with is spread over many places (the mangle table to MARK), then 'rules' 
and 'tables', spreading an action into many places increases the chances 
of getting parts out of sync and having the whole not work as intended. 
And the 'ip' man page defines everything in BNF, which was hot stuff 
when Algol-60 came out (1960) but which is only readable to people who 
use it frequently.

The ipt_ROUTE allows putting all parts of of the action, from defining 
the set of matching packets to specifying the desired result, the 
routing. And if that changes, it need only change in one place.

Making good administration difficult because it fits some pedantic metal 
model is NOT a good way to decide which features to offer in a kernel.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
