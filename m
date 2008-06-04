Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbYFDLaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbYFDLaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYFDLaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:30:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYFDLaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:30:05 -0400
Date: Wed, 4 Jun 2008 13:29:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: collapse the various size-dependent percpu
	accessors together
Message-ID: <20080604112939.GA27845@elte.hu>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <48466BFB.40004@goop.org> <4846725D.4090607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846725D.4090607@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jeremy Fitzhardinge wrote:
>> We can use gcc's %z modifier to emit the appropriate size suffix for
>> an instruction, so we don't need to duplicate the asm statement for
>> each size.
>
> Nah, it's a disaster.  Drop this one.

hm, what's the problem with it? What you are trying to do here looks 
like a nice cleanup - assuming it results in the same instructions 
emitted ;-)

	Ingo
