Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZKMQgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZKMQgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZKMQgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:36:39 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:50546 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbZKMQgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:36:39 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911111238.22696.rjw@sisk.pl>
	<87pr7pi40p.fsf@tac.ki.iif.hu> <200911111547.21149.rjw@sisk.pl>
Date: Fri, 13 Nov 2009 17:35:55 +0100
In-Reply-To: <200911111547.21149.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 11 Nov 2009 15:47:21 +0100")
Message-ID: <87my2qwff8.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Yes, echo "core" to /sys/power/pm_test before executing s2disk.

It snapshots the system and returns, producing the same console output
as s2ram (is this the expected behaviour?)  I ran this several times in
a loop, and experienced no problems at all.  Maybe it depends on the
amount of memory used...  I saw a freeze saying "99% done" (ie. not
100%), btw.  Are other pm_test values meaningful with s2disk?  Is this
handled explicitly in s2disk, or does simply the kernel act as if it was
resumed instead of providing the system image after SNAPSHOT_CREATE_IMAGE?

> On Wednesday 11 November 2009, Ferenc Wagner wrote:
>
>> I already did the test for STR (see
>> http://bugs.freedesktop.org/show_bug.cgi?id=22126#c3), but will redo
>> with the current kernel tonight.
>
> OK, thanks.

No change on this front, FWIW.  But rc7 is out now, I'll test again.
-- 
Thanks,
Feri.
