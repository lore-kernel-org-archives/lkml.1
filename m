Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbXKJHN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbXKJHN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 02:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXKJHNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 02:13:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:39326 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXKJHNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 02:13:50 -0500
To: Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       tglx@linutronix.de, hpa@zytor.com,
       Chuck Ebbert <76306.1226@compuserve.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 - 32-bit ptrace emulation mishandles 6th arg
From: Andi Kleen <andi@firstfloor.org>
References: <20071107154839.GA5981@c2.user-mode-linux.org>
	<20071107211222.B95634D0564@magilla.localdomain>
Date: Sat, 10 Nov 2007 08:13:47 +0100
In-Reply-To: <20071107211222.B95634D0564@magilla.localdomain> (Roland McGrath's message of "Wed\,  7 Nov 2007 13\:12\:22 -0800 \(PST\)")
Message-ID: <p73mytm1sk4.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> Sure has my ACK.  
> I never really understood why my old patch was not taken 2.5 years ago.

If I remember correctly the old patch back then broke some programs,
so it was reverted.

It's certainly ugly that it leaks r9 internals to ptrace.
Also it generates redundant code with CLEAR_RREGS.

-Andi
