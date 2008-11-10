Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYKJRsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYKJRsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYKJRsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:48:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42517 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbYKJRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:48:07 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
From: Andi Kleen <andi@firstfloor.org>
References: <20081109140726.GB1786@ucw.cz> <20081110075216.GD2093@elte.hu>
	<20081110075529.GD707@atrey.karlin.mff.cuni.cz>
	<20081110080436.GF2093@elte.hu> <20081110082836.GB1969@elf.ucw.cz>
	<20081110125335.GB28643@elte.hu>
Date: Mon, 10 Nov 2008 19:05:34 +0100
In-Reply-To: <20081110125335.GB28643@elte.hu> (Ingo Molnar's message of "Mon, 10 Nov 2008 13:53:35 +0100")
Message-ID: <878wrrpic1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> i can only suggest some stupid tweaking of the above options - for 
> example, does the bug scenario change in any way if you switch it over 
> to CONFIG_DISCONTIGMEM=y ?

iirc we removed that some time ago so it would probably need some
source hackery. There is only vmemmap or flat left.

-Andi

-- 
ak@linux.intel.com
