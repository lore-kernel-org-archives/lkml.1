Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXKGXmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXKGXmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXKGXmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:42:42 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33113 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXKGXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:42:41 -0500
Date: Wed, 7 Nov 2007 18:41:50 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Chuck Ebbert <76306.1226@compuserve.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 - 32-bit ptrace emulation mishandles 6th arg
Message-ID: <20071107234150.GA10520@c2.user-mode-linux.org>
References: <20071107154839.GA5981@c2.user-mode-linux.org> <20071107211222.B95634D0564@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107211222.B95634D0564@magilla.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 01:12:22PM -0800, Roland McGrath wrote:
> Sure has my ACK.  
> I never really understood why my old patch was not taken 2.5 years ago.

Nor I.  It's needed.

As is your PTRACE_SET_THREAD_INFO patch from yesterday - with these
two fixes, I can boot a 32-bit UML on a 64-bit host.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
