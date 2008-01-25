Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYAYEmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYAYEmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 23:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYAYEmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 23:42:03 -0500
Received: from gw.goop.org ([64.81.55.164]:49958 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbYAYEmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 23:42:01 -0500
Message-ID: <47996895.3010703@goop.org>
Date: Thu, 24 Jan 2008 20:41:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	<479634A9.1090908@zytor.com>	<1201031325.15491.66.camel@cthulhu.hellion.org.uk>	<47964B7B.9000905@zytor.com> <20080122203611.GA12892@elte.hu>	<1201121530.30671.15.camel@cthulhu.hellion.org.uk>	<4797E487.8010108@goop.org>	<1201167544.30671.64.camel@cthulhu.hellion.org.uk>	<47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org>	<479913BA.8000506@zytor.com> <47991809.9060903@goop.org>	<47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org>	<479922D0.3010708@zytor.com> <4799248F.9080404@goop.org>	<47992710.2060108@zytor.com> <47992948.60308@goop.org>	<47992A3B.7000607@zytor.com> <47992DD9.8060604@goop.org>	<47992F31.1070705@zytor.com> <m1d4rqipex.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d4rqipex.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Note.  I don't believe we use either trampoline (cpu startup or acpi wakeup)
> in the hypervisor case (esp Xen).  So we should be able to completely ignore
> Xen and do the memcpy of pgd entries.
>   

Indeed.  The alias mapping can be set up in 
native_pagetable_setup_done() and needn't involve Xen at all.

> I expect Xen gives us other cpus already in protected mode (which is overall
> the sane thing to do).

Quite so.

    J
