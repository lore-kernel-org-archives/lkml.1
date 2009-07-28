Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZG1SpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZG1SpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZG1SpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:45:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55831 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZG1SpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:45:08 -0400
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
From: Andi Kleen <andi@firstfloor.org>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
Date: Tue, 28 Jul 2009 20:45:06 +0200
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com> (Robert Richter's message of "Tue, 28 Jul 2009 19:07:00 +0200")
Message-ID: <87ljm8hcjx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:
>  	  If unsure, say N.
>  
> +config OPROFILE_EVENT_MULTIPLEX
> +	bool "OProfile multiplexing support (EXPERIMENTAL)"
> +	default n
> +	depends on OPROFILE && X86
> +	help
> +	  The number of hardware counters is limited. The multiplexing
> +	  feature enables OProfile to gather more events than counters
> +	  are provided by the hardware. This is realized by switching
> +	  between events at an user specified time interval.
> +

I would suggest to drop that CONFIG and have the code unconditional.
It's not a lot code and should be always available.

Will do more detailed review later and will look at Intel P6 support.

Where's the userland support for this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
