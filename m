Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab0BPRpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:45:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab0BPRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:45:33 -0500
Date: Tue, 16 Feb 2010 18:44:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
Message-ID: <20100216174437.GA28323@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com> <20100216140242.GC16448@redhat.com> <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Linus Torvalds wrote:
>
> And after we have switched to 32-bit mode, we _are_ inside a 32-bit system
> call: the execve has "changed" from a 64-bit one to a 32-bit one.
>
> So I really don't understand why you dislike TS_COMPAT here.

and, following this logic, shouldn't set_personality_64bit() clear
TS_COMPAT ?

OK, in any case I do not claim we need fixes. Just I am confused.

Oleg.

