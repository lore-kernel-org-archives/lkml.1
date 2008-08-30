Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYH3Cno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYH3Cno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYH3Cng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:43:36 -0400
Received: from main.gmane.org ([80.91.229.2]:35157 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYH3Cnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:43:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: An idea .... with code
Date: Fri, 29 Aug 2008 22:57:27 -0400
Message-ID: <g9ac4c$lm5$1@ger.gmane.org>
References: <20080827074751.GO26610@one.firstfloor.org>	 <35042.98883.qm@web33207.mail.mud.yahoo.com>	 <20080827124734.GT26610@one.firstfloor.org> <1219848575.9776.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <1219848575.9776.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> On Wed, 2008-08-27 at 14:47 +0200, Andi Kleen wrote:
>>>  As far as features are concerned, please suggest me what could be done with /dev/loop0 and not for /dev/vblk?
>> Serious question?  cryptoloop, offsets are the big ticket items,
>> i'm sure there are more.
> 
> As far as cryptoloop goes, isnt that obsoleted anyway? is there anyone
> that doesent use dm-crypt by now?

I, for one, have never been able to figure out how to use dm-crypt with 
cryptoloop files. If I had, for instance, a file and knew that if I 
started at a certain offset using a certain encryption with a certain 
key, and I wanted to mount my part of it, I have never persuaded 
dm-crypt to do that.

All proposed solutions have started  with copy or convert, neither of 
which are practical with this data.
> 
> as for offsets, isnt this a logical thing to do with devicemapper
> aswell?
> 
> ofcourse loop/losetup cannot just be removed, theres probably LOTS of
> scripts around which are being used.
> 

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

