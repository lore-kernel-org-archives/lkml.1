Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXBFPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXBFPxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXBFPxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:53:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:35124 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663AbXBFPxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:53:23 -0500
Message-ID: <45C8A411.7020006@tmr.com>
Date: Tue, 06 Feb 2007 10:51:45 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>	 <20070205084523.GA21858@elte.hu>	 <1170682488.29759.795.camel@pmac.infradead.org>	 <20070205155627.GA8354@elte.hu>	 <1170692539.29759.856.camel@pmac.infradead.org>	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>	 <1170710272.29759.894.camel@pmac.infradead.org>	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>	 <1170711587.29759.909.camel@pmac.infradead.org>	 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>	 <1170712393.29759.925.camel@pmac.infradead.org>	 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>	 <20070205143110.fca62b57.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>	 <1170717694.29759.941.camel@pmac.infradead.org>	 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org> <1170755101.29759.960.camel@pmac.infradead.org>
In-Reply-To: <1170755101.29759.960.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Mon, 2007-02-05 at 15:32 -0800, Linus Torvalds wrote:
>> On Mon, 5 Feb 2007, David Woodhouse wrote:
>>> The netfilter example is totally irrelevant here, since 'select' is
>>> neither necessary nor sufficient for that. Russell and I have both
>>> pointed that out to you already.
>> No, the example IS relevant.
>>
>> Why?
>>
>> Because you don't seem to be getting the whole "be nice" part.
> 
> If you'd come down from your high horse for a moment you might realise
> that I _agree_ with the 'be nice' part, as long as you don't pessimise
> things for those who _do_ know what they're doing. 
> 
> The thing you want for netfilter is a _GOOD IDEA_. I agree. I've even
> implemented something _very_ similar, for JFFS2 compression options. If
> you want to play about with individual compressors you have to enable
> the 'Advanced options' first; otherwise you get the sane defaults.
> Unless you really want to get your hands dirty, you don't have to know
> which compressors we use by default.

One thing which can be solved at the tool level, particularly for 
netfilter, is to provide options for "turn it all of and I'll select," 
"turn it all on (or module)," and "reset this page to defaults." Because 
those starting points will cover a majority of the options. Useful for 
device drivers as well, particularly network cards and disk controllers, 
where there are a vast number of choices.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
