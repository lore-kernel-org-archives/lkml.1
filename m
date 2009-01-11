Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZAKOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZAKOv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZAKOvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:51:18 -0500
Received: from mirapoint21.brutele.be ([212.68.199.158]:53521 "EHLO
	mirapoint21.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZAKOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:51:17 -0500
Message-ID: <496A073D.4070804@tvcablenet.be>
Date: Sun, 11 Jan 2009 15:50:37 +0100
From: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #12216] Error when drm is loaded
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.35C.HbfaJB@chimera>
In-Reply-To: <nHCfeC0YLrE.A.35C.HbfaJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki a écrit :
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12216
> Subject		: Error when drm is loaded
> Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
> Date		: 2008-12-13 09:59 (30 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50
>
>
>
>   
This problem has been solved by the following patch:

commit 077ebed54fe66612f58b076628a72eca2be8df90
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 22 17:11:02 2008 +1000

    drm/radeon: fix correctness of irq_enabled check for radeon.


This fix is in kernel 2.6.28, so this bug can be removed from the
regression list.

François Valenduc
