Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYK0Oln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYK0Oln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYK0Olf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:41:35 -0500
Received: from www.tglx.de ([62.245.132.106]:53930 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYK0Ole (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:41:34 -0500
Date: Thu, 27 Nov 2008 15:40:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: eranian@gmail.com, sfr@canb.auug.org.au, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <20081127.033742.175440395.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811271540190.3325@localhost.localdomain>
References: <alpine.LFD.2.00.0811261727200.3325@localhost.localdomain> <7c86c4470811270151i33ffaa44mb5d9bd79f9d73968@mail.gmail.com> <alpine.LFD.2.00.0811271132290.3325@localhost.localdomain> <20081127.033742.175440395.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> >   __attribute__ ((packed)); ???
> 
> Shouldn't be needed and this woule kill performance on RISC (every
> struct member is accessed with byte sized loads and shifts/masking).
> 
> We did this for the pfkey.h structures by accident, and I truly regret
> it.

Fair enough.

Thanks,

	tglx
 
