Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYFBFme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYFBFme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFBFm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:42:27 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:56490 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYFBFm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:42:26 -0400
Message-ID: <48438840.7050106@skyrush.com>
Date: Sun, 01 Jun 2008 23:42:24 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de>
In-Reply-To: <48438126.3080308@t-online.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Joe Peterson wrote:
>> Hi Harold,
>>
>> Doing "ps" while hung shows stty in the "T" state.  "killall -9 stty"
>> releases it.
>>
> 
> Does strace give you the same output if you attach it to the blocking
> stty (strace -p $pid)?
> 
> I got
> 
> 
> :
> ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo ...}) = ? ERESTARTSYS (To be restarted)
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---

Yep, almost the same.  I get (repeating):

ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig icanon echo
...}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---


			-Joe
