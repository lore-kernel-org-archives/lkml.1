Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZFEQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZFEQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZFEQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:25:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZFEQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:25:21 -0400
Message-ID: <4A2946B9.3070701@zytor.com>
Date: Fri, 05 Jun 2009 09:24:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
References: <1243865115.24278.8.camel@nathan.suse.cz> <1244215559.1604.12.camel@nathan.suse.cz> <20090605162738.GI1065@one.firstfloor.org>
In-Reply-To: <20090605162738.GI1065@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Any comments on this? It doesn't change anything. It only makes it
>> harder to break vDSOs by accident (such as the latest buglet with TSC
>> synchronization).
> 
> Looks ok to me. Although it would have been nicer if you hadn't mixed
> that many changes together.
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>
> 

It would have.  That makes review harder, and right at the moment time
is a bit at a premium.  It looks like a good cleanup, but it also looks
like it's going to need some testing, which means that since it is not a
functional change I would feel best if we could put it on the .32 track
after the imminent merge window craziness is over.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

