Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZGGQd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZGGQd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbZGGQdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:33:41 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37927 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851AbZGGQdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:33:40 -0400
Date: Tue, 7 Jul 2009 09:33:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] trivial: fix typo "that that" in multiple files
Message-ID: <20090707163336.GE6692@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1246976551.3613.33.camel@ht.satnam> <1246975428.3613.10.camel@ht.satnam> <16660.1246981034@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16660.1246981034@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 04:37:14PM +0100, David Howells wrote:
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > -	three states, we know that that CPU has exited any previous RCU
> > +	three states, we know that CPU has exited any previous RCU
> 
> That's probably wrong.  Look at it as "we know that _that_ CPU".
> 
> > -likely that that process will submit another request soon, and that
> > +likely that process will submit another request soon, and that
> 
> Ditto.  Most people would actually say two 'that' words here, and the emphasis
> goes on the second one.

Would it be possible to reword as for the RCU example?  The "that that"
can read awkwardly even for native English (or, for that matter, American)
speakers, even though it sounds quite natural in spoken English.

	"likely that this process will submit another request soon, and that"

							Thanx, Paul

> > -caches are expected to be coherent, there's no guarantee that that coherency
> > +caches are expected to be coherent, there's no guarantee that coherency
> 
> NAK.  This is correct before.  This doesn't make any sense with the second
> 'that' removed.
> 
> > -        1), and 3 means that that the strategy is always enabled.
> > +        1), and 3 means that the strategy is always enabled.
> 
> This is probably correct.  The second 'that' or the 'the' is wrong because both
> the second 'that' and the 'the' are trying to specify the strategy.
> 
> > -Here we see that that we had a latency of 12 microsecs (which is
> > +Here we see that we had a latency of 12 microsecs (which is
> 
> Correct.
> 
> > ...
> 
> Various of the remainder are incorrect.
> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
