Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYJVCkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYJVCkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 22:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYJVCj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 22:39:57 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:3432 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYJVCj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 22:39:56 -0400
X-IronPort-AV: E=Sophos;i="4.33,461,1220241600"; 
   d="scan'208";a="76977323"
Message-ID: <48FE923A.70002@analog.com>
Date: Wed, 22 Oct 2008 10:38:50 +0800
From: Bryan Wu <bryan.wu@analog.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
CC: Mike Frysinger <vapier.adi@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [RFC] CRIS: Move header files from include to arch/cris
References: <20081021164211.GG24715@axis.com> <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com> <20081021191736.GH24715@axis.com>
In-Reply-To: <20081021191736.GH24715@axis.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 02:38:04.0334 (UTC) FILETIME=[356D84E0:01C933EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Nilsson wrote:
> On Tue, Oct 21, 2008 at 07:46:18PM +0200, Mike Frysinger wrote:
>   
>> On Tue, Oct 21, 2008 at 12:42, Jesper Nilsson <jesper.nilsson@axis.com> wrote:
>>     
>>> That means that the machine dependent header files are moved to
>>> arch/cris/mach-{fs,a3}/include, while the common and architecture
>>> dependent files are moved to arch/cris/include.
>>>
>>> It is mainly this I'd like some input on, since most other ports
>>> that have moved their header files have put all headers in arch/*/include.
>>>       
>> that seems like a fairly obvious good idea to me ... i'm thinking we
>> should do it for Blackfin as well ...
>>     
>
> I'm still not decided, my main reason for following Blackfin and ARM
> was that it seemed good to collect all mach-specific files in one place
> in the tree.
>
> However, keeping them in the same place makes it easy to grep through,
> something I use quite frequently.
>
>   
For grepping, just use "find arch/blackfin -name *.h | xargs grep ......."
I think is ok for you, though "grep -r xxxx arch/blackfin/include" is 
more simple.

-Bryan
