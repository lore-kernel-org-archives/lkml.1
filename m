Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075Ab0ARJx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0ARJx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671Ab0ARJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:53:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33693 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0ARJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:53:25 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
From: Andi Kleen <andi@firstfloor.org>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
	<1262700774-1808-5-git-send-email-gleb@redhat.com>
	<1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com>
	<1263740980.557.20980.camel@twins>
Date: Mon, 18 Jan 2010 10:53:20 +0100
In-Reply-To: <1263740980.557.20980.camel@twins> (Peter Zijlstra's message of "Sun, 17 Jan 2010 16:09:40 +0100")
Message-ID: <87ljfv4u3z.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Whatever are we doing to end up in do_page_fault() as it stands? Surely
> we can tell the CPU to go elsewhere to handle faults?
>
> Isn't that as simple as calling set_intr_gate(14, my_page_fault)
> somewhere on the cpuinit instead of the regular page_fault handler?

That typically requires ugly ifdefs in entry*S and could be described
as code obfuscation ("come from")

As long as he avoids a global reference (patch) the if should be practially
free anyways.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
