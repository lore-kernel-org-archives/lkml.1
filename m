Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZGVPEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZGVPEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGVPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:04:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49600 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZGVPE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:04:29 -0400
Subject: Re: GFS2: Add LED support to GFS2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
In-Reply-To: <20090722145534.GA6035@basil.fritz.box>
References: <1248260198.3456.4.camel@localhost.localdomain>
	 <87k5203hdx.fsf@basil.nowhere.org>
	 <1248274288.3298.5.camel@localhost.localdomain>
	 <20090722145534.GA6035@basil.fritz.box>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 22 Jul 2009 16:02:31 +0100
Message-Id: <1248274951.3298.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-07-22 at 16:55 +0200, Andi Kleen wrote:
> > It would be difficult to make that generic since the errors and the
> > resulting actions which can be taken vary from fs to fs. The main reason
> > that I didn't do it at this point in time is that the GFS2 error
> > handling needs revising anyway, and once that is done (probably with an
> > errors= option similar to ext2/3/4) it might be possible to think about
> > LED support for that,
> 
> I was thinking to have a couple of generic functions like:
> 
> log_activity()
> error_happened() 
> 
> ...
> 
> that everyone could call.
> 
> -Andi
> 
> 
Indeed, but we'd need to allow for different classes of activity or
errors, and then filtering them per-LED. With my proposed patch that is
avoided due to having a small number of triggers on the different
events, so selecting the trigger acts as a filter on the event type.

So I guess what I'm really getting at, is what would the user interface
be for this scheme to set up the LEDs?

I did consider adding a feature to filter events on a per superblock
basis, but I decided against it in the end, as it seemed to be making
things too complicated (how should we specify the superblock? what
should the user interface be?).

Maybe there is an easy way to do that which I've not spotted...

Steve.


