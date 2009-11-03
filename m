Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZKCLDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZKCLDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZKCLDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:03:17 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:36538 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZKCLDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:03:16 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu>
	<9b2b86520910310502p7fe8e0edmff09220632fab5e2@mail.gmail.com>
	<874opfwtde.fsf@tac.ki.iif.hu> <200910312011.04005.rjw@sisk.pl>
	<87iqdtvrn6.fsf@tac.ki.iif.hu>
Date: Tue, 03 Nov 2009 12:02:32 +0100
In-Reply-To: <87iqdtvrn6.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Sun,
	01 Nov 2009 22:53:17 +0100")
Message-ID: <87fx8veurb.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

A)

> So: with the new s2disk I got a freeze again after S|.  After a manual
> power off and a successful resume, I switched to shutdown mode and
> hibernated again, and got the exact same freeze (apart from a slightly
> different image size).  Power off, resume, switch to reboot mode,
> hibernate, and this worked.  Switch back to shutdown, now that worked
> as well...  Eh.  In my earlier bug report I think I noted that after
> such a hibernation failure a straight shutdown didn't power off the
> computer as it otherwise does, which feels consistent with the above.

B)

> Now something else, which may or may not be related.  I supervise a
> computing farm running a very old OS: Debian Sarge.  The kernel was
> somewhat newer: 2.6.24 until recently, when new machines arrived to the
> lab, which couldn't boot that 2.6.24 kernel.  So I upgraded to 2.6.31,
> which works quite well, apart from one thing: halt doesn't power off the
> machines anymore.  All the same under 2.6.32-rc5: they simply freeze
> after reaching halt -d -f -i -h -p in the shutdown sequence.

Hi,

so now I've got three ACPI and/or PM related problems: A) and B) above
with hibernation and halt/poweroff, and the C) graphics and suspend
related described at http://bugs.freedesktop.org/show_bug.cgi?id=22126
(which turned out to be ACPI related recently).

B) and C) are 100% reproducible, although the machines exhibiting C) are
at a different geographic location, so I have to bug a remote admin for
power switching.

A) and C) are exhibited by my laptop.

I'd be grateful for debugging tips for any of the above.  While A) is
not reproducible, it happens often enough with the platform method (I
haven't got enough data with the shutdown method yet).  I'm willing to
recompile kernels, read up on documentation and code and have parallel
port LEDs handy (for the laptop).  But I've got no experience with ACPI
or PM, sadly.  However, 2.6.32 is currently nominated as more than a
couple of distros' choice for long term stable support, so I'm willing
to invest substantial effort into fixing these issues.

If anybody has debugging tips, please share (and note if further
questions aren't welcome).
-- 
Thanks,
Feri.
