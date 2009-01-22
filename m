Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZAVNhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZAVNhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZAVNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:37:04 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:42496 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZAVNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:37:03 -0500
Message-ID: <4978767D.4060700@intertwingly.net>
Date: Thu, 22 Jan 2009 08:37:01 -0500
From: Sam Ruby <rubys@intertwingly.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware summary: http://tinyurl.com/ap79ra
APIC details: http://intertwingly.net/stories/2009/01/22/
Note acpidump.err: Wrong checksum for OEMB!

Messages on boot using Intrepid, Jaunty Alpha 3, or Fedora 10:

[    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 
  Boot with apic=debug and send a report.  Then try booting with the 
'noapic' option.
[    0.296001]

Able to get past this issue using "noapic", at which point things mostly 
work, but rsync of large iso images result in corrupt files.  Able to 
copy those same files using Vista on the same machine, or using Hardy on 
another machine.  This problem may not be related to the above, but it 
seems plausible to me that this might be an interrupt issue.

memtest86+ runs clean.

Quite willing to invest time in installing kernels or distributions on 
fresh hard drives, run tests, obtain debug information, and report back.

More background here: http://intertwingly.net/blog/2009/01/20/noAPIC

Not subscribed, but will actively monitor the web archives for this 
mailing list for the next several days.

- Sam Ruby
