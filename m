Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZA3HVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZA3HVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZA3HVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:21:32 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:36900 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZA3HVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:21:31 -0500
Date: Fri, 30 Jan 2009 08:21:30 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
In-Reply-To: <1233297635.17301.11.camel@localhost>
Message-ID: <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
References: <1233294584.28741.2.camel@localhost>  <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr> <1233297635.17301.11.camel@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-01-30 07:40, Nathanael Hoyle wrote:
>On Fri, 2009-01-30 at 07:16 +0100, Jan Engelhardt wrote:
>
>The one discussion I saw referencing SCHED_BATCH seemed to imply that it
>was a non-standard kernel patch by Con Kolivas in one of his -ck
>variants that never made it into mainline and is not being maintained.
>Is this inaccurate?

The presence of SCHED_BATCH in linux/sched.h tells me it is available
(on the other hand, SCHED_ISO, also from -ck, is only listed as a comment.)

>I was unfamiliar with SCHED_IDLE. Having done a little Googling now, I
>finally find reference to the man page for sched_setscheduler(2). This
>appears that it is likely what I wanted.
>
>I think the information I had been able to find was somehwat out of
>date.

The manpage does say it, but if your local distro does not 
mention SCHED_BATCH/SCHED_IDLE, then that's a pretty sad distro.

The doc in sched_setschedule seems complete to me as of man-pages 3.13.

>Is there currently a standardized userspace tool to use to run a command
>in order to alter its scheduling class? Obviously writing one would be
>trivial, but didn't know if something like:

man chrt
