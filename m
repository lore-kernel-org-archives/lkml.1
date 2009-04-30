Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbZD3MVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbZD3MVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZD3MVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:21:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZD3MVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:21:20 -0400
Date: Thu, 30 Apr 2009 14:21:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090430122101.GA32751@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430115741.GA23634@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> > -Andi (who thinks all of this decoding should be in user space 
> > anyways)
> 
> Think of a big data center with a thousands of 2,4,8 socket blades 
> and the admin collecting mce output and running around decoding 
> the errors on his workstation. Even worse, the blades have 
> different DIMM configurations due to hw upgrades/newer machines. 
> I'd much rather have the complete decoding done in kernel, where 
> all the information needed for proper decoding is present and with 
> the error landing in syslog or some other monitored buffer instead 
> of reconstructing it in userspace.

Yes, this aspect of the design is correct. The MCE code is seriously 
mis-designed that way, lets not repeat it for EDAC :)

	Ingo
