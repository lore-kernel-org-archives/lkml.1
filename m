Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbXHMUo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbXHMUo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764735AbXHMUog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:44:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46231 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762797AbXHMUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:44:34 -0400
Date: Mon, 13 Aug 2007 13:44:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rene Herman <rene.herman@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
In-Reply-To: <46BF66F4.9030106@gmail.com>
Message-ID: <Pine.LNX.4.64.0708131343270.27728@schroedinger.engr.sgi.com>
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
 <46BE621E.9090509@gmail.com> <9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
 <46BE7BB6.2010607@gmail.com> <20070812013519.a5d5d59b.akpm@linux-foundation.org>
 <46BF66F4.9030106@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, Rene Herman wrote:

> > >          /*
> > >           * Maximum threshold is 125
> > >           */
> > >          threshold = min(125, threshold);
> > > 
> > > as either the comment or the code is wrong and it seems it's the code.
> > > Added Andrew Morton to the CC for that.
> > 
> > Yes, that's inconsistent.  And looking at Christoph's df9ecaba it's unclear
> > whether the comment is wrong or the code is wrong.  The code is wrong, I
> > expect.

?? What is wrong with the code? We want the threshold to stay below 125?
 
> On 08/12/2007 05:29 AM, Roland Dreier wrote:
> 
> > What's the problem? That line sets threshold to the smaller of the current
> > value or 125, which is exactly what one would want to do if the
> > maximum value is 125. Just do a couple of examples: eg if threshold is
> > 100 going into that line, then the value is left alone; if threshold is
> > 150 then it gets set to 125; and that seems exactly correct.

Exactly.

