Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYKJMi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYKJMi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYKJMiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:38:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57583 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYKJMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:38:20 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
From: Andi Kleen <andi@firstfloor.org>
References: <20081109140726.GB1786@ucw.cz> <20081110075216.GD2093@elte.hu>
	<20081110075529.GD707@atrey.karlin.mff.cuni.cz>
	<20081110080436.GF2093@elte.hu>
Date: Mon, 10 Nov 2008 13:55:44 +0100
In-Reply-To: <20081110080436.GF2093@elte.hu> (Ingo Molnar's message of "Mon, 10 Nov 2008 09:04:36 +0100")
Message-ID: <87hc6fpwof.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> No good ideas - the bug description gives me the impression of memory 
> maps save/restore hickup in the hibernation code - and memory maps are 
> pretty much the only thing that are significantly different on NUMA. 

I assume the problem happened on a single node system.
On single node the memory map should be actually quite similar
to the UMA case.

One possibility would be to bisect if it ever worked?

-Andi

-- 
ak@linux.intel.com
