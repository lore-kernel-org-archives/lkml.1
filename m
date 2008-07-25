Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYGYDuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYGYDuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 23:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYGYDuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 23:50:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63425 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYGYDuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 23:50:24 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5346"; a="4872668"
Message-ID: <48894D88.9010104@qualcomm.com>
Date: Thu, 24 Jul 2008 20:50:32 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: James Le Cuirot <chewi@aura-online.co.uk>,
       suspend-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [Suspend-devel] TAP (and TUN?) devices not working after resume
References: <20080714154720.791f6640@symphony> <200807141812.45264.rjw@sisk.pl>
In-Reply-To: <200807141812.45264.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rafael J. Wysocki wrote:
> On Monday, 14 of July 2008, James Le Cuirot wrote:
>> Hi,
> 
> Hi,
> 
>> uswsusp works great on my machine except for one thing. I use a TAP
>> device for QEMU and after resuming from suspend, it doesn't work
>> anymore until I delete it and recreate it. This is rather annoying
>> because if I have QEMU open, it means I have to close it before
>> recreating the interface and then boot Windows up again. I use OpenVPN
>> to create/delete the interface but I think that's all it does. The rest
>> is done by the kernel. So I'm guessing something's up with the TUN/TAP
>> driver or uswsusp itself. I'm using version 0.8. Sorry if this has
>> already been fixed.
> 
> This is a kernel problem, adding kernel-related CCs.

I bet it's flow control related. I've fixed a bug in flow control handling for
persistent devices recently.
btw Does it still happen with >= 2.6.26 ?

I'll play with some test code on my laptop and see if I can reproduce this issue.

Max
