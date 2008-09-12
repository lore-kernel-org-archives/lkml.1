Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYILVUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYILVUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYILVU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:20:29 -0400
Received: from www.tglx.de ([62.245.132.106]:37154 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYILVU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:20:28 -0400
Date: Fri, 12 Sep 2008 23:19:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
In-Reply-To: <878wtxrrwh.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Andi Kleen wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >
> > to see how wrong could be set by BIOS.
> 
> Just dump it from user space then.  There are plenty of tools
> to access ACPI tables.

1.) what guarantees that we reach user space ?

2) If it is _valuable_ information which we can gather via kernel
   output, then it is much more conveniant than asking the user to type
   whatevercryptictoolcommandline and provide the output.

Nervertheless the changelog of the patch needs some useful information
why we actually need this information.

Thanks,

	tglx
