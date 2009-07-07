Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbZGGPpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbZGGPpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbZGGPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:45:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51208 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbZGGPpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:45:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1246976551.3613.33.camel@ht.satnam>
References: <1246976551.3613.33.camel@ht.satnam> <1246975428.3613.10.camel@ht.satnam>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dhowells@redhat.com, trivial <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] trivial: fix typo "that that" in multiple files
Date: Tue, 07 Jul 2009 16:37:14 +0100
Message-ID: <16660.1246981034@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> -	three states, we know that that CPU has exited any previous RCU
> +	three states, we know that CPU has exited any previous RCU

That's probably wrong.  Look at it as "we know that _that_ CPU".

> -likely that that process will submit another request soon, and that
> +likely that process will submit another request soon, and that

Ditto.  Most people would actually say two 'that' words here, and the emphasis
goes on the second one.

> -caches are expected to be coherent, there's no guarantee that that coherency
> +caches are expected to be coherent, there's no guarantee that coherency

NAK.  This is correct before.  This doesn't make any sense with the second
'that' removed.

> -        1), and 3 means that that the strategy is always enabled.
> +        1), and 3 means that the strategy is always enabled.

This is probably correct.  The second 'that' or the 'the' is wrong because both
the second 'that' and the 'the' are trying to specify the strategy.

> -Here we see that that we had a latency of 12 microsecs (which is
> +Here we see that we had a latency of 12 microsecs (which is

Correct.

> ...

Various of the remainder are incorrect.

David
