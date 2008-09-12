Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYILV1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYILV1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYILV04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:26:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38598 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbYILV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:26:55 -0400
Date: Fri, 12 Sep 2008 23:30:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080912213053.GR7714@one.firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1.) what guarantees that we reach user space ?

Broken SLITs don't prevent booting.

> 2) If it is _valuable_ information which we can gather via kernel
>    output, then it is much more conveniant than asking the user to type
>    whatevercryptictoolcommandline and provide the output.

Yes excellent point.  Should we dump the complete ACPI tables?
Do you prefer hexdump or do we need a ASL disassembler?
Also complete SMBIOS? Also the legacy mptables of course too.
And all the EFI methods.  Ideally a disassembly of the complete BIOS.
Did I miss anything?

-Andi
