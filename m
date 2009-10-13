Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbZJMQyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbZJMQyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZJMQya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:54:30 -0400
Received: from claw.goop.org ([74.207.240.146]:40044 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbZJMQy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:54:29 -0400
Message-ID: <4AD4B0A0.6050200@goop.org>
Date: Tue, 13 Oct 2009 09:53:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: unify sys_iopl
References: <4ABD3EC2.1020104@goop.org> <20091013103044.GA3915@elte.hu> <4AD4A9AE.10306@zytor.com>
In-Reply-To: <4AD4A9AE.10306@zytor.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/09 09:24, H. Peter Anvin wrote:
> First of all, the unification looks good.
>
> As far as .32 is concerned... this *is* a bug even if this is only for
> paravirt, and given the small amount of code I am personally OK with
> taking the whole patch for .32.
>
> However, the patch is not complete!  The patch incidentally eliminates
> the need to have assembly stubs for sys_iopl, and those assembly stubs
> should be removed.  I have a patch for that currently test building.
>   

I wasn't sure whether task_pt_regs() needed the full register set to be
saved to correctly return rflags (that is, does PTREGSCALL change the
shape of the stack, or just the contents?).

    J
