Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbYCDLQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbYCDLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYCDLQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:16:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56968 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbYCDLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:16:51 -0500
Date: Tue, 4 Mar 2008 12:17:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080304111715.GB23227@elf.ucw.cz>
References: <200803030316.07165.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803030316.07165.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-03 03:16:06, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2008-03-03      115       65          49
>   2008-02-25       90       51          39
>   2008-02-17       61       45          37


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9995
> Subject		: 2.6.25-rc1 regression - backlight controlls do not work - ThinkPad T61
> Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
> Date		: 2008-02-15 04:51
> Handled-By	: Zhang Rui <rui.zhang@intel.com>

Actually, I see this one too. Witch 2.6.25-rc3, brightness keys just
do not work. I can still control brightness if I load acpi video
module and do 

root@amd:/sys/class/backlight/acpi_video0# echo 1 > brightness 

.


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10012
> Subject		: 2.6.24-git4+ regression

Better  description would be "interactivity problems in -git4+".

> Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Date		: 2008-01-30 14:56
> References	: http://lkml.org/lkml/2008/1/30/254
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> 		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

And he has GROUP_SCHED enabled, that is known broken. 

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10022
> Subject		: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-02-13 09:41
> References	: http://lkml.org/lkml/2008/2/13/82
> 		  http://lkml.org/lkml/2008/2/16/17
> Handled-By	: Jiri Kosina <jkosina@suse.cz>
> 		  Mike Galbraith <efault@gmx.de>

This is duplicate of 10012.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
