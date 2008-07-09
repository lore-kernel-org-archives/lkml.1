Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYGIVE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYGIVE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYGIVES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:04:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbYGIVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:04:17 -0400
Date: Wed, 9 Jul 2008 23:03:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709210356.GC4298@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502FB.3090106@sgi.com> <487507A1.2020100@goop.org> <m1r6a2yfip.fsf@frodo.ebiederm.org> <4875212E.6090404@goop.org> <m18wwavkxz.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wwavkxz.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
> >> Or we could do something completely evil.  And use the other segment
> >> register for the stack canary.
> >>
> >
> > That would still require gcc changes, so it doesn't help much.
> 
> We could use %fs for the per cpu variables.  Then we could set %gs to 
> whatever we wanted to sync up with gcc

one problem is, there's no SWAPFS instruction.

	Ingo
