Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbZJGRLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbZJGRLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZJGRLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:11:15 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:55785 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZJGRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:11:15 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [regression, bisected] adb trackpad disappears after suspend to ram
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	<200906032200.55563.rjw@sisk.pl> <1253676745.7103.268.camel@pasglop>
	<200909231538.51227.rjw@sisk.pl> <1253741332.7103.324.camel@pasglop>
Date: Wed, 07 Oct 2009 19:10:13 +0200
In-Reply-To: <1253741332.7103.324.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 24 Sep 2009 07:28:52 +1000")
Message-ID: <878wfnt9je.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> Alternatively, you could introduce a new flag IRQF_NOSUSPEND and use that
>> instead of IRQF_TIMER.  That would be cleaner than using IRQF_TIMER for
>> non-timer interrupts IMHO.
>
> I totally agree. The current patch is still good for stable though.
>
> I'll send it to Greg after I've upstreamed it, we can introduce IRQF_NOSUSPEND
> in a second patch.

How's upstreaming going? I can neither find the patch in Linus branch,
nor in linux-next. Could it be that it got lost?

Cheers,
Jan
