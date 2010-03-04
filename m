Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0CDOze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:55:34 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:38747 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0CDOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:55:32 -0500
Message-ID: <4B8FC9F8.1050700@Calva.COM>
Date: Thu, 04 Mar 2010 15:55:52 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++
 on different filesystems seems to deadlock in sync
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM> <20100303120317.GP5768@kernel.dk> <20100303144241.GF21495@skl-net.de>
In-Reply-To: <20100303144241.GF21495@skl-net.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> On 13:03, Jens Axboe wrote:
>
>   
>> Our sync is currently broken in that regard, since it'll wait for too
>> long. We have a debated patch going, I have included it below. Any
>> chance you could give it a whirl?
>>     
>
> That's the same patch you posted two weeks ago and on which Linus
> commented he thinks it is broken. He also proposed another, simpler
> patch (included below) which I'm running for a few days and which
> fixes the sync problem for me.
>   
I've tried the "simpler patch" on my system and it makes no difference 
for me.
