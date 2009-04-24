Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbZDXNt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbZDXNt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZDXNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:49:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47936 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZDXNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:49:07 -0400
To: "ext Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 24 Apr 2009 16:44:22 +0300
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> (ext Rafael J. Wysocki's message of "Thu\, 16 Apr 2009 23\:42\:31 +0200")
Message-ID: <87ljpqqi89.fsf@nokia.com>
User-Agent: Gnus/5.101 (Gnus v5.10.10) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2009 13:44:26.0377 (UTC) FILETIME=[C8971F90:01C9C4E2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message contains a list of some regressions from 2.6.29, for
> which there are no fixes in the mainline I know of. If any of them
> have been fixed already, please let me know.
>
> If you know of any other unresolved regressions from 2.6.29, please
> let me know either and I'll add them to the list. Also, please let
> me know if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply to
> this message with CCs to the people involved in reporting and handling the
> issue.
>

[...]

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13067
> Subject         : iwl3945: wlan0: beacon loss from AP - sending probe request
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2009-04-05 9:11 (12 days old)
> References      : http://marc.info/?l=linux-kernel&m=123892272218266&w=4

The regression here is that I added a printk() to inform about beacon
loss. The issue has been there a long time, the printk() just exposed
it.

Michael wrote a patch which silences the printk:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=16eaea5faa37d552b14e246ca56a436e55ca67b3

I fixed the beacon loss detection here:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=3b6dc5a431e4fef35717cba53544a95209f49b68

John, I think Michael's patch should be sent to 2.6.30. Any chances
for that?

Rafael, is it possible to send your regression mails to
linux-wireless@vger.kernel.org as well? Very few wireless developers
have time to follow netdev or lkml.

-- 
Kalle Valo
