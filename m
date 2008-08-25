Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYHYOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYHYOPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYHYOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:14:51 -0400
Received: from 1wt.eu ([62.212.114.60]:2639 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYHYOOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:14:51 -0400
Date: Mon, 25 Aug 2008 16:13:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: Joe Peterson <joe@skyrush.com>
Cc: Chris Frey <cdfrey@foursquare.net>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Visible Ctrl-C in latest kernels
Message-ID: <20080825141354.GB19337@1wt.eu>
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu> <48B2BAE7.4010702@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2BAE7.4010702@skyrush.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, Aug 25, 2008 at 08:00:07AM -0600, Joe Peterson wrote:
> Willy Tarreau wrote:
> >>> Chris, yes, what you are now seeing on the newer kernel is correct.
> >> Thanks guys.  I was not aware of this change before asking.  The change
> >> makes sense.  I wasn't having any problems with it, just wondering where
> >> it came from.
> >>
> >> Thanks for the enlightenment. :-)
> > 
> > I would not be surprized that it is what has caused delays for Ctrl-C
> > to take effect for some of us. As discussed in another thread on the
> > subject, the problem was relatively recent and not easy to reproduce.
> > Now we have a patch to try to revert if/when we finally get a reproducible
> > case.
> 
> It seems very unlikely that the echo has anything to do with it, other
> than making the problem more visible.  See this post:
> 
> 	http://marc.info/?l=linux-kernel&m=121526224222656&w=2

possible, indeed.

> And to what patch of yours are you referring?

not mine, I was speaking about your patch of 2008/02/06 which was
talked about earlier in this thread. I was thinking that it was
possible that the signal got delayed when it was hard to print
^C because the output was already busy spewing a stream of data.
Maybe I'm wrong, but I mean it does not cost much to try to revert
this patch when the problem is encountered. And I keep in mind
that it is possible, as you say, that your patch only makes the
problem more visible.

Regards,
Willy

