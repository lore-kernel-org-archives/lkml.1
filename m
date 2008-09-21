Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYIUMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYIUMGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIUMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 08:06:07 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:37480 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYIUMGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 08:06:06 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: doubled idle count
References: <87vdwtfxng.fsf@tac.ki.iif.hu> <48D2AD5E.7040602@goop.org>
Date: Sun, 21 Sep 2008 14:05:59 +0200
In-Reply-To: Ferenc Wagner's message of "Fri, 19 Sep 2008 18:53:35 +0200"
Message-ID: <87hc89g0uw.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> --text follows this line--
>> Ferenc Wagner wrote:
>>
>>> After upgrading a Xen virtual machine to Debian's 2.6.26-4 kernel, I
>>> noticed that the idle counter doubled its pace on one of the machines:
>>> [...]
>>> One out of three machines show this effect, with the exact same kernel
>>> and Xen versions (3.2.0, dom0 is Debian's stock Etch 2.6.18 kernel).
>>> They aren't hosted by the same machine, though: the misbehaving one is
>>> on a different installation with very similar hardware (3 vs 2 GHz).
>>> All the guest are paravirtual.
>>
>> So you're saying that they are identical Xen and guest kernel binaries,
>> but one of three is showing doubled idle time?
>
> Now I upgraded another domU, and that also shows this doubling effect,
> so I've got two domUs (running on xen2-ha) misbehaving, and other two
> (running on xen2) behaving correctly.

Possibly related: three out of the above four 2.6.26 domUs froze
yesterday afternoon.  The consoles don't show anything and are dead,
they don't react to sysrq, even.  According to xm list, the frozen
domains are constantly running (stuck in r state).

I haven't destroyed them yet, in case it is possible to extract any
info from the system.  If not, please tell me so I can restart them.

On the other hand, I'll have a look whether the same kernel running on
the bare metal produces this idle count discrepancy.
-- 
Thanks,
Feri.

Ps: Please note that xen-devel swallows my mails without a trace,
    probably because I'm not subscribed.
