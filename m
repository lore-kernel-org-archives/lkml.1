Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZGGRTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZGGRTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZGGRSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:18:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbZGGRSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:18:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090707163336.GE6692@linux.vnet.ibm.com>
References: <20090707163336.GE6692@linux.vnet.ibm.com> <1246976551.3613.33.camel@ht.satnam> <1246975428.3613.10.camel@ht.satnam> <16660.1246981034@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] trivial: fix typo "that that" in multiple files
Date: Tue, 07 Jul 2009 18:17:57 +0100
Message-ID: <19787.1246987077@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> The "that that" can read awkwardly even for native English (or, for that
> matter, American) speakers, even though it sounds quite natural in spoken
> English.

I think it sounds quite natural when you say it because you say them
differently - or at least I do.  The first 'that' is a conjunction, and the
second a determinative.  Possibly the determinative should be in italics, but
that's hard to do in plain text.

> Would it be possible to reword as for the RCU example?
> ...
> 	"likely that this process will submit another request soon, and that"

This is actually the as-iosched.txt example.

To use the RCU example:

	Therefore, as soon as a CPU is seen passing through any of these
	three states, we know that that CPU has exited any previous RCU
	read-side critical sections.

I think that in this example, "a CPU" should be paired with the "that"
determinative because you're not talking about the CPU you've got in your hand
per se, but a random CPU over there.

If you instead said "this CPU", being more specific, I think that's when you'd
use the "this" determinative:

	Therefore, as soon as this CPU is seen passing through any of these
	three states, we know that this CPU has exited any previous RCU
	read-side critical sections.

Of course, I'm not a qualified linguist - I know enough to make stuff up and
hopefully make it sound plausible.

David
