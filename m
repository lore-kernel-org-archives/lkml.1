Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXIZKY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXIZKY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXIZKYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:24:21 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34318 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbXIZKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:24:20 -0400
Message-ID: <46FA334F.7030802@davidnewall.com>
Date: Wed, 26 Sep 2007 19:54:15 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>	<46F29A9A.4070806@davidnewall.com>	<200709201817.17282@x5>	<46F2B59F.8090709@davidnewall.com>	<46F2DDD0.3030500@tmr.com>	<46F380E4.4040606@davidnewall.com>	<20070924213215.GA32716@vino.hallyn.com>	<46F83474.5040503@davidnewall.com>	<20070924230008.GA3160@vino.hallyn.com>	<46F8BC8A.7080006@davidnewall.com>	<20070925114947.GA9721@vino.hallyn.com>	<46F91417.9050600@davidnewall.com>	<46F924E3.50205@davidnewall.com>	<20070925163040.12a3c2f8@the-village.bc.nu>	<46F92AAB.1060903@davidnewall.com>	<20070925164806.4cadc6a5@the-village.bc.nu>	<46F99EDE.70905@davidnewall.com> <20070926011847.49bbb9a2@the-village.bc.nu>
In-Reply-To: <20070926011847.49bbb9a2@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Good call.  Though I suppose, since it's used 24x7 to aid security on 
>> countless production servers, that security dwarfs testing.  Still, 
>> debugging, yes that's valid.
>>
>> I don't suppose it makes and difference; whatever the purpose, a chroot 
>> that doesn't change the root is buggy.
>>     
>
> It does change the root, it just doesn't guarantee you can't change it
> back - which is correct POSIX, Unix, SuS behaviour. So either everyone
> else is wrong or you are.. I know who I am betting on
>   

Charming.  They really say that, do they?  Where?  I find no such thing, 
and I looked.  I did find Open Groups SuS which, similar to SCO's UNIX, 
says:
> The dot-dot entry in the root directory is interpreted to mean the 
> root directory itself. Thus, dot-dot cannot be used to access files 
> outside the subtree rooted at the root directory.

I feel I've presented a good case that that it's a bug.  You made a 
somewhat rude counter-claim, which I don't ascribe to malevolence.  
You're simply disinterested.  Nobody else cares, so why expend effort on 
it, right?  I'll let it drop, but it is a bug.
