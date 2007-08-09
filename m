Return-Path: <linux-kernel-owner+w=401wt.eu-S1763960AbXHIUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763960AbXHIUd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbXHIUdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:33:47 -0400
Received: from rtr.ca ([64.26.128.89]:3377 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbXHIUdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:33:47 -0400
Message-ID: <46BB7A29.4080409@rtr.ca>
Date: Thu, 09 Aug 2007 16:33:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 
References: <1186504459.6949.40.camel@pc.ilinx>
In-Reply-To: <1186504459.6949.40.camel@pc.ilinx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brian J. Murrell wrote:
> I am using Ubuntu Gutsy, which is the in-development branch heading for
> their next stable release.
> 
> I have noticed that since some kernel release post-2.6.20 I have been
> unable to mount my /boot partition:
> 
> $ sudo strace -f mount /dev/hda1 /mnt/foo
> execve("/bin/mount", ["mount", "/dev/hda1", "/mnt/foo"], [/* 41 vars*/])= 0
...                             = 0
> mount("/dev/hda1", "/mnt/foo", "ext3", MS_MGC_VAL, NULL) = -1 EBUSY (Device or resource busy)
> rt_sigprocmask(SIG_UNBLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
> write(2, "mount: /dev/hda1 already mounted"..., 50mount: /dev/hda1 already mounted or /mnt/foo busy) = 50
...
> All other block devices (all LVM LVs) seem to mount with no problems.

Probably something to do with either LVM or the Device Mapper having
the raw partition already "open" for some remapping purpose.
There was a note about that around here somewhere quite recently..

??

