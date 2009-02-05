Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZBEAFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZBEAFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZBEAFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:05:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZBEAFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:05:10 -0500
Date: Thu, 5 Feb 2009 01:04:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
Message-ID: <20090205000450.GA15680@elte.hu>
References: <20090204192551.GA19539@elte.hu> <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain> <20090204225848.GA3251@elte.hu> <498A2129.4030408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A2129.4030408@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>
>> The solution is (based on Linus's suggestion) to compare 64-bits
>                                                   ^not, presumably
>> (on 64-bit x86), but to do the comparison on 32-bit signed
>> integers.

fixed, thanks!

	Ingo
