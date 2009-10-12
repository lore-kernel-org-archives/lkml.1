Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZJLVM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZJLVM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbZJLVM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:12:58 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:33095 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbZJLVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:12:56 -0400
Date: Mon, 12 Oct 2009 23:12:58 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
	helper
Message-ID: <20091012211258.GA21213@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Stable Kernel <stable@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen-devel <xen-devel@lists.xensource.com>
References: <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org> <4ACA90F2.1060909@goop.org> <20091006033050.GA6332@wavehammer.waldi.eu.org> <4ACB93F8.5010900@goop.org> <20091007163521.GA17998@wavehammer.waldi.eu.org> <4ACD3346.3010307@goop.org> <20091012205208.GE17163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091012205208.GE17163@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:52:08PM +0200, Ingo Molnar wrote:
> ping - any update about this fix? Since it fixes a real crash it would 
> be nice to fix this for .32.

It works nicely.

But IMHO this whole infrastructure should go for now, at least until gcc
is able to produce functions with this call convention on its own. Or it
needs to be restricted to only assembler functions. The other users of
this may only work because the stack protector is already disabled for
arch/x86/xen/mmu.o.

Bastian

-- 
Men will always be men -- no matter where they are.
		-- Harry Mudd, "Mudd's Women", stardate 1329.8
