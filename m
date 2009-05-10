Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZEJR5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZEJR5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 13:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZEJR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 13:57:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZEJR5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 13:57:07 -0400
Message-ID: <4A07155A.8030601@zytor.com>
Date: Sun, 10 May 2009 10:56:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com> <4A03F016.76EA.0078.0@novell.com> <874ovvo0wo.fsf@basil.nowhere.org> <4A0492EA.6080403@zytor.com> <20090508205347.GC23223@one.firstfloor.org> <4A049B99.4000402@zytor.com> <20090509100008.GD23223@one.firstfloor.org> <4A06778E.9030908@zytor.com> <20090510151804.GE23223@one.firstfloor.org>
In-Reply-To: <20090510151804.GE23223@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Well right now we ignore ACPI/PNP data, sometimes ignore PCI data 
> and only look in e820 and sometimes only use PCI/e820 and sometimes
> only use SRAT (or at least it was like this at some point)
> 

That *is* a conflict resolution policy.  Quite probably an accidental one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

