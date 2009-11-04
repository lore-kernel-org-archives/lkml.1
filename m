Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZKDPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZKDPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZKDPl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:41:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836AbZKDPl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:41:57 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
References: <bug-14537-6666@http.bugzilla.kernel.org/>
	<alpine.LFD.2.00.0911041142370.12138@localhost.localdomain>
	<87vdhq8gpc.fsf@basil.nowhere.org>
X-Yow: HOW could a GLASS be YELLING??
Date: Wed, 04 Nov 2009 16:41:34 +0100
In-Reply-To: <87vdhq8gpc.fsf@basil.nowhere.org> (Andi Kleen's message of "Wed,
	04 Nov 2009 16:14:55 +0100")
Message-ID: <m3d43ys3f5.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Thomas Gleixner <tglx@linutronix.de> writes:
>
>>> - with gnome-terminal:
>>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
>>> arg(48111345) on /dev/pts/0
>>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
>>> arg(4811134a) on /dev/pts/0
>>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
>>> arg(48111351) on /dev/pts/0
>>
>> That looks more like an application problem. 'S' is SNDRV_SEQ_IOCTL
>> which has no ioctl nr 0xb. Also I have no idea why a sound sequencer
>> ioctl should work on /dev/pts/0 :)
>
> ioctl numbers are not always unique (I haven't checked if this is the
> case here).  But it might be that it's some other ioctl actually.

'S' is also used for streams ioctls, 0x530b is I_FIND.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
