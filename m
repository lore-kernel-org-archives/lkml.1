Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbYBGUN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbYBGUN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYBGUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:13:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933665AbYBGUNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:13:21 -0500
Message-ID: <47AB6652.3010600@redhat.com>
Date: Thu, 07 Feb 2008 15:13:06 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user	space
References: <20080205075137.617012701A8@magilla.localdomain>	<20080205080149.GA16929@elte.hu> <20080205081506.655CB2701A8@magilla.localdomain>
In-Reply-To: <20080205081506.655CB2701A8@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2008 03:15 AM, Roland McGrath wrote:
>> thanks, applied. I suppose you have a testcase for this that we could try?
> 
> This should exit 0 and show "wait status 0xb7f", and does on i386.
> On 2.6.24 it exits 1 and shows "wait status 0xb".
> 
> Note, on the current tree before [PATCH] x86_64: fix iret exception recovery
> that I also posted today, this will instead produce pathological weirdness
> probably with a quick crash or silent reboot, from running with the wrong GS.
> 

Did you test without CONFIG_PARAVIRT, and CONFIG_PARAVIRT booted both with and
without the "noreplace-paravirt" parameter?

