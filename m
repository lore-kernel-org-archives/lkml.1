Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbXHUKlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbXHUKlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXHUKli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:41:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbXHUKlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:41:37 -0400
Date: Tue, 21 Aug 2007 12:41:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070821104121.GA26598@elte.hu>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC7BDA.3000305@googlemail.com> <6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com> <m11webz8dx.fsf@ebiederm.dsl.xmission.com> <20070810160519.GA27500@elte.hu> <m1odhfxqi0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odhfxqi0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ok.  I missed that.  Duh.  I just saw Andrews drop message.
> 
> This looks like Alexey respun my patch, or else we were thinking on 
> parallel paths.  Probably parallel given Alexey's dislike of using the 
> CTL_UNNUMBERED define.
> 
> There are two remaining gotchas:
> - The directories have impossible permissions (writeable).
> 
> - The ctl_name for the kernel directory is inconsistent with
>   everything else.  It should be CTL_KERN.

thx, i've applied your patch to my tree.

> I kind of feel bad about being so picky but the this code is the only 
> place in the kernel where I have seen us violate either of those 
> rules, and it is a lot easier to deal with things when they are 
> consistent.

sure enough, i'm not opposed at all to fixing these issues. We should 
move your debug-sysctl-bugs patch upstream ASAP.

	Ingo
