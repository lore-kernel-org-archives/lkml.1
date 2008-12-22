Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYLVMZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYLVMZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYLVMZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:25:37 -0500
Received: from styx.suse.cz ([82.119.242.94]:57572 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752018AbYLVMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:25:37 -0500
Date: Mon, 22 Dec 2008 13:25:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mpm@selenic.com, tytso@mit.edu
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref of
 0x20)
In-Reply-To: <494F823E.9060607@gmail.com>
Message-ID: <alpine.LNX.1.10.0812221325000.26265@jikos.suse.cz>
References: <4935C03A.7030603@gmail.com> <20081202153336.7b765ec7.akpm@linux-foundation.org> <alpine.LRH.1.10.0812031400040.28179@twin.jikos.cz> <494F823E.9060607@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Jiri Slaby wrote:

> >> Presumably your machine picked a different clocksource from Arjan's, 
> >> mine and others.  Now, how do we work out what clocksource you're using?
> >> dmesg -s 1000000 | grep -i clock
> >> nope
> >> dmesg -s 1000000 | grep -i using
> >> nope
> >> hrm.
> > cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> It ran from qemu, but it oopsed even on my desktop (tsc too).

Could you please send the full oops to Thomas and Ingo?

-- 
Jiri Kosina
SUSE Labs
