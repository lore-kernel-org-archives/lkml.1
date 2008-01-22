Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYAVUgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYAVUgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYAVUgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:36:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYAVUgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:36:31 -0500
Date: Tue, 22 Jan 2008 21:36:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080122203611.GA12892@elte.hu>
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <47939363.8040603@kolumbus.fi> <1200950633.15491.21.camel@cthulhu.hellion.org.uk> <479510CE.7010706@zytor.com> <1200951996.15491.28.camel@cthulhu.hellion.org.uk> <479551FD.5040801@zytor.com> <1201023401.5643.52.camel@localhost.localdomain> <479634A9.1090908@zytor.com> <1201031325.15491.66.camel@cthulhu.hellion.org.uk> <47964B7B.9000905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47964B7B.9000905@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> Seems reasonable to me. I'll integrate your asm diff with the other 
>> changes and give it a whirl.
>
> This version boots into userspace on both PAE and !PAE.  You want to 
> take it from here?

ok, i'll wait for Ian to submit the final (tested) version then. A few 
possible complications are: PSE-less boxes, 32-bit PAGEALLOC bootups 
with tons of RAM, NX-less boxes and NX-able boxes :)

	Ingo
