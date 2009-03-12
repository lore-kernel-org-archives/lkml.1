Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZCLNcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZCLNcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZCLNcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:32:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55727 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZCLNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:31:59 -0400
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, resend] i386: also limit NODES_HIGH_SHIFT here
From: Andi Kleen <andi@firstfloor.org>
References: <49B90F12.76E4.0078.0@novell.com>
Date: Thu, 12 Mar 2009 14:29:37 +0100
In-Reply-To: <49B90F12.76E4.0078.0@novell.com> (Jan Beulich's message of "Thu, 12 Mar 2009 12:33:06 +0000")
Message-ID: <87vdqeeuny.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:

> Impact: configuration bug fix
>
> Just like for x86-64, the range of widths valid for NODE_SHIFT is not
> unbounded. The upper bound 64-bit uses is definitely also an upper
> bound for 32-bit.

I think that's actually obsolete, there's no real 128 nodes limit.

The only limit used to be 256 nodes because you can't have more nodes
than CPUs, but that's obsolete with x2apic.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
