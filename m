Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXB1WD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXB1WD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXB1WD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:03:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498AbXB1WD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:03:58 -0500
Date: Wed, 28 Feb 2007 14:00:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       jkarlson@cc.hut.fi
Subject: Re: [Bugme-new] [Bug 8100] New: dynticks makes ksoftirqd1 use
 unreasonable amount of cpu time
Message-Id: <20070228140023.46bbba98.akpm@linux-foundation.org>
In-Reply-To: <200702281734.l1SHYAp0021968@fire-2.osdl.org>
References: <200702281734.l1SHYAp0021968@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 09:34:10 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8100
> 
>            Summary: dynticks makes ksoftirqd1 use unreasonable amount of cpu
>                     time
>     Kernel Version: 2.6.21-rc2
>             Status: NEW
>           Severity: low
>              Owner: johnstul@us.ibm.com
>          Submitter: jkarlson@cc.hut.fi
> 
> 
> Most recent kernel where this bug did *NOT* occur:
> any kernel without dynticks
> 
> Distribution:
> Debian etch with linux-2.6.21-rc{2,1}
> 
> Hardware Environment: 
> Macbook core2 with bios emulation
> 
> Software Environment:
> The problem is obvious when listening to shoutcast stream with kmplayer and 
> artsd via wi-fi with  wpa (wpa_supplicant)
> 
> Problem Description:
> ksoftirqd1 uses ~30% cpu-time (by top) no other symptoms, while
> without dyntikcs cpu-load in similar circumstances is negligible.
> This might be a dynticks feature rather than bug.
> 
> Steps to reproduce:
> Just watch the top, if the bug is reproducible, probably just booting should 
> suffice.
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
