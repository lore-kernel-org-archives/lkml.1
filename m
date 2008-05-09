Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbYEIM24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbYEIM24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYEIM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:28:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbYEIM2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:28:45 -0400
Date: Fri, 9 May 2008 14:28:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Glauber Costa <gcosta@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Message-ID: <20080509122828.GB10855@elte.hu>
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de> <48243D86.7020504@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48243D86.7020504@keyaccess.nl>
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 09-05-08 08:06, Takashi Iwai wrote:
>
>> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
>> implicit assumption that dev = NULL for ISA devices that require 24bit
>> DMA.
>>
>> How about the patch below?  It's against the latest Linus git tree.
>
> Yes, works well. Thank you.

great, thanks Rene for catching this! Added this line to the patch as 
well:

 Tested-by: Rene Herman <rene.herman@keyaccess.nl>

	Ingo
