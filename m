Return-Path: <linux-kernel-owner+w=401wt.eu-S937590AbZAPVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937590AbZAPVTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbZAPVTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:19:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZAPVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:19:00 -0500
Date: Fri, 16 Jan 2009 22:18:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
Message-ID: <20090116211849.GB10063@elte.hu>
References: <496DE927.76E4.0078.0@novell.com> <496E3F7D.2060908@zytor.com> <496F0796.76E4.0078.0@novell.com> <20090115085728.GA28607@elte.hu> <496F6DFC.90006@zytor.com> <49708423.76E4.0078.0@novell.com> <4970D04C.9080104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970D04C.9080104@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4992]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Jan Beulich wrote:
>>> If so, what would be the difference between HIGHMEM4G and HIGHMEM64G in
>>> that case at all?
>>
>> For example being able to select the DMADEVICES config option.
>
> WTF?!  Why would DMA device support be banned on HIGHMEM64G?  That makes 
> no sense whatsoever...

yes - but i guess the point is that there is some assymetry there which 
needs to be investigated and fixed.

	Ingo
