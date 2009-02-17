Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZBQWIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZBQWIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZBQWIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:08:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZBQWIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:08:38 -0500
Date: Tue, 17 Feb 2009 23:08:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Alain Knaff <alain@knaff.lu>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Message-ID: <20090217220825.GA24337@elte.hu>
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499B267E.2090509@zytor.com>
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

> Jan Engelhardt wrote:
>> On Monday 2009-01-05 00:58, H. Peter Anvin wrote:
>>> I have pulled the x86 parts of the bzip2/lzma patchset into
>>> tip:x86/setup-lzma.  I would appreciate it if you could look at it and
>>> make sure it looks sane.  I have not added the ARM portions (patch 4),
>>> since those should go via the ARM tree, nor the capstone patch 5, which
>>> can only be added after the old code is removed from *all* remaining
>>> architectures.
>>
>> It seems to work well here. It would be cool if this finds its way
>> into mainline sometime.
>
> There were some build failures with "make randconfig" I seem 
> to recall.  Those need to be addressed soon if we're going to 
> be able to push this for .30.

Correct. I'll merge it into tip:master again and will report any 
breakages, should they occur.

	Ingo
