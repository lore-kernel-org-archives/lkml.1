Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYFBFM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYFBFM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYFBFMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:12:19 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:40277 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYFBFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:12:18 -0400
Message-ID: <48438126.3080308@t-online.de>
Date: Mon, 02 Jun 2008 07:12:06 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: Joe Peterson <joe@skyrush.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com>
In-Reply-To: <48434D57.6030801@skyrush.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EP1RCmZ1QhUJ7hr672584KvbD11XWhqbxvJa-A0i06Fd+4ak2nMc0Ktcr9c6lJZgL5
X-TOI-MSGID: 4a4ddec8-d3b4-4ab9-95bc-eb927efda3af
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Joe Peterson wrote:
> Hi Harold,
> 
> Doing "ps" while hung shows stty in the "T" state.  "killall -9 stty"
> releases it.
> 

Does strace give you the same output if you attach it to the blocking
stty (strace -p $pid)?

I got


:
ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo ...}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
:


Regards

Harri

