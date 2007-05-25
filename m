Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXEYXxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXEYXxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXEYXwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:52:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbXEYXwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:52:53 -0400
Message-ID: <465776CE.5070007@zytor.com>
Date: Fri, 25 May 2007 16:52:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from	compressed
 boot wrapper
References: <98cd38b5.git.bcollins@ubuntu.com>	 <1180097543.12570.396.camel@cunning> <46573CE4.8080300@zytor.com>	 <200705251623.55551.jbarnes@virtuousgeek.org>  <46577112.7090106@zytor.com> <1180137053.12570.446.camel@cunning>
In-Reply-To: <1180137053.12570.446.camel@cunning>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins wrote:
> On Fri, 2007-05-25 at 16:28 -0700, H. Peter Anvin wrote:
>> Jesse Barnes wrote:
>>> But how often do you have to debug bootloader or compressed boot code?  In 
>>> fact, most debug output like this isn't very useful after some initial 
>>> debugging, so we usually take it out.  I'm not sure why this would be any 
>>> different...
>>>
>> You're asking me this?
>>
>> I get to hear all the time about some new platform -- sometimes exotic,
>> sometimes not -- breaking early boot.
> 
> Truth be told, I'd much rather just remove the informational pustr's and
> leave the error ones enabled. If it's acceptable, I can just remove
> those lines, or make them only work with -DDEBUG.

The problem with that is you don't have any idea how far a boot
proceeded before a hang.  That's actually a very important piece of
information.

	-hpa
