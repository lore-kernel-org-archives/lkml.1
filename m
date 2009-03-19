Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZCSOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZCSOeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCSOeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:34:03 -0400
Received: from shakaweb.org ([85.25.54.21]:37119 "EHLO shakaweb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbZCSOeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:34:01 -0400
Message-ID: <49C25712.9010509@shakaweb.org>
Date: Thu, 19 Mar 2009 15:30:42 +0100
From: Christopher Schramm <debian@shakaweb.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <49C1FE7D.9070605@shakaweb.org> <20090319100122.GA30358@elte.hu>
In-Reply-To: <20090319100122.GA30358@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 94.216.219.212
X-SA-Exim-Mail-From: debian@shakaweb.org
Subject: Re: APIC problem report
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shakaweb.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick replay, Ingo!

Following your request, I installed Debian 5.0. Had to use noapic again 
for getting the boot media to work (think it utilizes 2.6.26).

The kernel panic is the same for all three systems: "not syncing: 
IO-APIC + timer doesn't work!".

The installed system had the same problem (2.6.26 again), then I 
compiled 2.6.28.8 (with default config). Booting that one with APIC 
enabled throws the known "MP-BIOS bug" message, but then continues 
booting - no kernel panic.

I will try Knoppix' kernel config and your git code, when I find some 
spare time.

Christopher
