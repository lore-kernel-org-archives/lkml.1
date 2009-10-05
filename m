Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZJEWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZJEWnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZJEWnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:43:16 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:58083 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZJEWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:43:16 -0400
Date: Tue, 6 Oct 2009 00:43:10 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
	helper
Message-ID: <20091005224310.GA32144@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Stable Kernel <stable@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen-devel <xen-devel@lists.xensource.com>
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ACA2AFD.4080305@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 10:21:01AM -0700, Jeremy Fitzhardinge wrote:
> > Save all caller-saved registers on x86_32 for the paravirt callee saved
> > registers.
> That looks better, but it is still overkill.  We only need to save the
> set of registers the ABI requires the callee to preserve.  What
> additional register(s) gets clobbered by stack-protector that need to be
> saved?

Well, exactly the two, ecx and edx. eax is still clobbered by the return
value. Anyway, it works in praxis.

Bastian

-- 
Superior ability breeds superior ambition.
		-- Spock, "Space Seed", stardate 3141.9
