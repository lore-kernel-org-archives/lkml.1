Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122Ab0AAT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0AAT7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 14:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969Ab0AAT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 14:59:36 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:4201 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab0AAT7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 14:59:36 -0500
Message-ID: <4B3E53E1.7050104@unsolicited.net>
Date: Fri, 01 Jan 2010 19:58:25 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.33-rc1 - Weird hard hangs when rendering 'some' web-sites
 in 	Firefox
References: <4B2FEE46.5030700@unsolicited.net> <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com> <4B3E0061.4000003@unsolicited.net>
In-Reply-To: <4B3E0061.4000003@unsolicited.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Mine is a wired connection, so it seems unconnected with that. I've
> replaced the motherboard here and have had no further problems. There is
> now a configuration difference though as I've had to disable radeon kms
> (with radeon.modeset=0) for the new on-board graphics.
>
> My guess is that this is radeon related, and I'm going to set-up the old
> motherboard in a spare case & see what I can work out.
>   
I've just done some testing with the old motherboard, and I can
regularly hang the system solid while browsing. Applying
radeon.modeset=0 seems to stabilise it completely (at the cost of not
being able to use compiz).

So my issue is indeed radeon (using a discrete X300 (RV370) card).

Cheers
David


