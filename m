Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZI3WId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZI3WId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZI3WIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:08:32 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:41768 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZI3WIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:08:31 -0400
Message-ID: <4AC3D6DC.9010500@free.fr>
Date: Thu, 01 Oct 2009 00:08:28 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, mingo@elte.hu, xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>	<87iqf0o5sf.fsf@caffeine.danplanet.com> <4AC38477.4070007@free.fr>	<87eipoo0po.fsf@caffeine.danplanet.com> <4AC39CE5.9080908@free.fr> <877hvgnv6z.fsf@caffeine.danplanet.com>
In-Reply-To: <877hvgnv6z.fsf@caffeine.danplanet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Smith wrote:
> DL> Yep, I agree. But you didn't answer the question, what are the
> DL> network resources you plan to checkpoint / restart ?  eg. you let
> DL> the container to setup your network, will you restore netdev
> DL> statistics ? the mac address ? ipv4 ? ipv6 ?
>
> Yes, Yes, Yes, and Yes.  I'm making the assumption that the common
> case will be with a veth device in the container and that all of the
> aforementioned attributes should be copied over.  In the future case
> where we could potentially have a real device in the container, it
> probably doesn't make sense to copy the mac address.
>   

Be careful with the assumptions ;)
> DL> Is it possible to do a detailed list of network resources you plan
> DL> to CR with the different items you will address from userspace and
> DL> kernel space ?
>
> I'm sure it's possible, but no, I haven't planned out everything for
> the next year.  If you have strong feelings about what should be done
> in user and kernel space, feel free to share :)
>   

Dan,

I just want to understand what is your plan. If you say "yes I will 
checkpoint / restart" ipv4, ipv6, netdev statistics, etc ...  you should 
be able to give at least a small list of network resources you will 
checkpoint and how you will restart them, no ?

> DL> Argh ! I was hoping there was something else than the source code
>
> The header file makes it pretty clear what is going on, 
Certainly for you.
We are a little far away of the sys_checkpoint / sys_restart simple 
syscalls we talked about at the cr-minisummit in 2008.

Regards,
     -- Daniel



