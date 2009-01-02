Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbZABTDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbZABTDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZABTDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:03:09 -0500
Received: from main.gmane.org ([80.91.229.2]:44598 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624AbZABTDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:03:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Replace CONFIG_EMBEDDED [Was: x86 (Linux Tiny): configure out
 support for some processor]
Date: Fri, 02 Jan 2009 14:02:48 -0500
Message-ID: <495E64D8.1030200@tmr.com>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu> <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com> <20090102162120.GG1180@elte.hu> <3f9a31f40901020838v333a968dv937a717e031743eb@mail.gmail.com> <20090102173435.GE6759@elte.hu> <20090102181345.GB5905@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Valdis.Kletnieks@vt.edu, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <20090102181345.GB5905@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> It's a subjective category and no amount of talking will bring any 
>> solution here.
> 
> It is brought up now and then partly because the use of the
> term EMBEDDED that is so overloaded that it is not fun.
> 
> Someone should kill it and replace it with something saner.
> 
> CONFIG_EXPERT_TEXT_SIZE
> 
> For stuff that the expert can toy with which mainly
> has text size impact and some documented performance/functionality impact.
> The possibility to select a subset of CPU's may belong here.
> 
> 
> CONFIG_EXPERT_DATA_SIZE
> 
> Likewise where what we save is more data than TEXT.
> For example where we lower the size of a hash bucket etc.
> 
> CONFIG_EXPERT
> 
> For other stuff that no 'ordinary' user will need to change
> but the expert may find it usefull.
> 
> Everything we hide under EMBEDDED today would fit in the
> categories above.
> 
> 
Don't forget "CONFIG_EXPERT_STACK_SIZE" for 4k x86 stacks.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

