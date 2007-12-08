Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXLHQA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXLHQA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 11:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXLHQAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 11:00:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:41959 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbXLHQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 11:00:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JfyPlKSV69NsAd8lNqzIsqb4oJvWb6oyoxkw24hJvle023kcGhFDJAwufkb70ceE9LKqkmGWEaGN9xOxquObWlqTmi+zU7+N/+uRt1RnocgJNliKgcDpnWFMn1p+cjSF2Boj1ZPFlfqa9xdZ0o9pHnjTmbGjR1+xv2aTMAFrnM4=
Message-ID: <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com>
Date: Sat, 8 Dec 2007 11:00:47 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071208154755.GA5255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
	 <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
	 <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
	 <20071208154755.GA5255@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 10:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> does the patch below help? But the root cause is likely some timer
> problems - do you get consistent results from:
>

Haven't yet tried the patch - will try a little later.

>    while :; do time usleep 1111111; done
>
> or do these sleeps fluctuate?
>

They seem to fluctuate - not sure if that's supposed to be exact or if
below variations are normal -
This is when my compiles are running -

[parag@mini ~]$ while :; do time usleep 1111111; done

real    0m1.116s
user    0m0.000s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.130s
user    0m0.000s
sys     0m0.004s

real    0m1.144s
user    0m0.000s
sys     0m0.000s


Thanks
Parag
