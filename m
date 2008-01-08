Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYAHWSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYAHWSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYAHWRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:17:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbYAHWRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:17:01 -0500
Date: Tue, 8 Jan 2008 23:16:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] percpu: Per cpu code simplification V3
Message-ID: <20080108221646.GC21482@elte.hu>
References: <20080108021142.585467000@sgi.com> <20080108090702.GB27671@elte.hu> <Pine.LNX.4.64.0801081102450.2228@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801081102450.2228@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 8 Jan 2008, Ingo Molnar wrote:
> 
> > i had the patch below for v2, it's still needed (because i didnt 
> > apply the s390/etc. bits), right?
> 
> Well the patch really should go through mm because it is a change that 
> covers multiple arches. I think testing with this is fine. I think 
> Mike has diffed this against Linus tree so this works but will now 
> conflict with the modcopy patch already in mm.

well we cannot really ack it for x86 inclusion without having tested it 
through, so it will stay in x86.git for some time. That approach found a 
few problems with v1 already. In any case, v3 is looking pretty good so 
far - and it's cool stuff - i'm all for unifying/generalizing arch code.

	Ingo
