Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXIRW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXIRW17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXIRW1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:27:52 -0400
Received: from gw.goop.org ([64.81.55.164]:38287 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbXIRW1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:27:51 -0400
Message-ID: <46F050E8.5020206@goop.org>
Date: Tue, 18 Sep 2007 15:27:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com>
In-Reply-To: <46F04D53.6040903@zytor.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Allowing different registers should be doable, but if so, one would have
> to put 0: at the *end* of the instruction and use (0f)-4 instead, since
> the non-%eax forms are one byte longer.
>   

OK, that's already a problem since its using "=r" as the constraint.

> This also seems "safer", since an imm32 is always the last thing in the
> instruction.

Good idea.  If gas/gcc generates entirely the wrong addressing mode,
then we've got bigger problems.

    J
