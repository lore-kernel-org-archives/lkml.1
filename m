Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbZJMQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbZJMQ0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZJMQ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:26:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZJMQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:26:17 -0400
Message-ID: <4AD4A9AE.10306@zytor.com>
Date: Tue, 13 Oct 2009 09:24:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: unify sys_iopl
References: <4ABD3EC2.1020104@goop.org> <20091013103044.GA3915@elte.hu>
In-Reply-To: <20091013103044.GA3915@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 03:30 AM, Ingo Molnar wrote:
> 
> Pulled, thanks a lot Jeremy!
> 
> It's in tip:x86/paravirt right now. I'm uneasy about pushing this into 
> .32 - we had this status quo forever. Peter, Thomas, what do you think?
> 

First of all, the unification looks good.

As far as .32 is concerned... this *is* a bug even if this is only for
paravirt, and given the small amount of code I am personally OK with
taking the whole patch for .32.

However, the patch is not complete!  The patch incidentally eliminates
the need to have assembly stubs for sys_iopl, and those assembly stubs
should be removed.  I have a patch for that currently test building.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

