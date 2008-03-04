Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbYCDGxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbYCDGxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbYCDGxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:53:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbYCDGxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:53:30 -0500
Date: Tue, 4 Mar 2008 07:53:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080304065305.GA32287@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org> <47CC74E6.60306@linux.intel.com> <47CCA03D.9040007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CCA03D.9040007@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

>> I'm staring at the disassembly and it's quite different but 
>> follow_page() is rather large; trying to make a smaller testcase now
>
> sadly a more isolated testcase doesn't show the same behavior yet; so 
> it's some fun interaction ;(
>
> more staring at the assembly for me

could you post the "bad" and the "good" disassembled functions, and the 
specific gcc version string?

	Ingo
