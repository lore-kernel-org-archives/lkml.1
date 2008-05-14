Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYENRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYENRFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYENRFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:05:43 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:34845 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYENRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:05:42 -0400
Message-ID: <482B1BD2.8040400@t-online.de>
Date: Wed, 14 May 2008 19:05:22 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <4829326A.6060808@t-online.de>	 <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>	 <4829D345.7020909@t-online.de> <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>
In-Reply-To: <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: G0pCLBZVrhuaVQiy7n2rC-vizZlvf-XbFEfWSmURArq95BGJFEkRJ7fsmsf+80SwbV
X-TOI-MSGID: 08623df0-a0b6-4b2b-8179-b13f5098d7f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> Ah, tough luck. What if you attach an strace to the already stuck
> process? Like strace -p pid. It's a long shot, but worth a try, I
> suppose.
> 

As suggested I attached strace to the blocking stty. I got a
continuous flow of

:
:
ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig icanon echo ...}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
:
:

I also moved back to an old version of coreutils from about
4 months ago. Same result.


Regards

Harri

