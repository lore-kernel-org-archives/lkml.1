Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZKSRxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZKSRxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZKSRxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:53:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZKSRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:53:53 -0500
To: Nick Piggin <npiggin@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
From: Andi Kleen <andi@firstfloor.org>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
	<20091116041407.GB5818@wotan.suse.de>
	<4B011677020000780001FD9D@vpn.id2.novell.com>
	<20091116105657.GE5818@wotan.suse.de> <20091119035640.GA18236@elte.hu>
	<20091118205240.11d3d660@infradead.org>
	<20091119081307.GA20534@wotan.suse.de>
	<20091119075958.2cba15f8@infradead.org>
	<20091119161807.GC5602@wotan.suse.de>
Date: Thu, 19 Nov 2009 18:53:58 +0100
In-Reply-To: <20091119161807.GC5602@wotan.suse.de> (Nick Piggin's message of "Thu, 19 Nov 2009 17:18:07 +0100")
Message-ID: <87my2i4czt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>
> AFAIKS, in any case that 128 byte alignment is used, cache footprint
> should not increased on a 64B line system, over 64 byte alignment.

Yes.

It's probably some silly bug somewhere. I don't think we should
completely abandon P4 systems (of which there are still plenty around)
just for silly bugs, that can be probably properly fixed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
