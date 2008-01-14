Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYANKdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYANKdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYANKdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:33:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbYANKdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:33:32 -0500
Date: Mon, 14 Jan 2008 11:33:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Fix x86 32 bit FRAME_POINTER chasing code
Message-ID: <20080114103305.GA27977@elte.hu>
References: <20080109220421.630d3516@laptopd505.fenrus.org> <20080110065438.GA23022@elte.hu> <478670BA.6010600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478670BA.6010600@redhat.com>
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> > it's a 2.6.24.1 candidate i believe. We trigger plenty of various 
> > crashes during x86.git maintenance and others hit various crashes in 
> > -mm, so by the time .1 is released we'll have it in .25 and can 
> > backport it. Most folks/distros will update to 2.6.24.1 very quickly 
> > so there's no risk of months loss of quality to kerneloops.org data 
> > either.
> 
> Using the same logic, why not put it in 2.6.24 and then remove it in 
> 2.6.24.1 if it's broken?

hm, did you understood my .25 reference to mean 2.6.25-final? I meant 
2.6.25-rc1. Or if there's a 2.6.24-rc8 planned then we could put it in 
right now [with the bisectability fixes, i.e. not the original series]. 
I.e. IMO what we shouldnt do is to put in these fixes without having had 
_some_ -rc release inbetween.

	Ingo
