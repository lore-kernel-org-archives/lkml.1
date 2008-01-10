Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYAJNtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYAJNtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYAJNtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:49:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYAJNtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:49:23 -0500
Date: Thu, 10 Jan 2008 14:48:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, travis@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 10/10] x86: Unify percpu.h
Message-ID: <20080110134835.GE5886@elte.hu>
References: <20080108211023.923047000@sgi.com> <20080108211025.293924000@sgi.com> <1199906905.9834.101.camel@localhost> <Pine.LNX.4.64.0801091130420.11317@schroedinger.engr.sgi.com> <1199908430.9834.104.camel@localhost> <Pine.LNX.4.64.0801091210300.11709@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801091210300.11709@schroedinger.engr.sgi.com>
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

> On Wed, 9 Jan 2008, Dave Hansen wrote:
> 
> > Then I really think this particular patch belongs in that other 
> > patch set.  Here, it makes very little sense, and it's on the end 
> > anyway.
> 
> It makes sense in that both percpu_32/64 are very small as a result of 
> earlier patches and so its justifiable to put them together to 
> simplify the next patchset.

i'd agree with this - lets just keep the existing flow of patches 
intact. It's not like the percpu code is in any danger of becoming 
unclean or quirky - it's one of the best-maintained pieces of kernel 
code :)

	Ingo
