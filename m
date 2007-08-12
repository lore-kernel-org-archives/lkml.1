Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXHLIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXHLIvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbXHLIvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:51:12 -0400
Received: from 1wt.eu ([62.212.114.60]:1651 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbXHLIvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:51:11 -0400
Date: Sun, 12 Aug 2007 10:41:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
Message-ID: <20070812084112.GL6002@1wt.eu>
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com> <46BE621E.9090509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BE621E.9090509@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 03:27:58AM +0200, Rene Herman wrote:
> On 08/12/2007 03:08 AM, Jesper Juhl wrote:
> 
> >This may be a little off topic, but I think it's interresting enough
> >to warrent a single mail.
> >
> >I just saw a news article (http://www.theinquirer.net/?article=41610)
> >about a 3 Socket Opteron motherboard and couldn't help but wonder if
> >we are prepared to deal with such a beast, so I thought I'd inform
> >everyone :-)
> >
> >I'm guessing equipping such a board with 3 single core CPU's could
> >show up some interresting corner cases in schedular code and
> >elsewhere, I'll bet we have some assumptions somewhere about
> >nr_of_cpus being an even number...
> 
> I would hope the N=1 case will have flushed out enough of those... :-|

Well, 1 could be seen as even number in base 2, it's 2^0 and has only
one bit set.

Willy

