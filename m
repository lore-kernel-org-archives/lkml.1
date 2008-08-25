Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYHYOA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYHYOA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYHYOAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:00:13 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:41968 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbYHYOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:00:11 -0400
Message-ID: <48B2BAE7.4010702@skyrush.com>
Date: Mon, 25 Aug 2008 08:00:07 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Chris Frey <cdfrey@foursquare.net>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Visible Ctrl-C in latest kernels
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu>
In-Reply-To: <20080825122024.GA19337@1wt.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>>> Chris, yes, what you are now seeing on the newer kernel is correct.
>> Thanks guys.  I was not aware of this change before asking.  The change
>> makes sense.  I wasn't having any problems with it, just wondering where
>> it came from.
>>
>> Thanks for the enlightenment. :-)
> 
> I would not be surprized that it is what has caused delays for Ctrl-C
> to take effect for some of us. As discussed in another thread on the
> subject, the problem was relatively recent and not easy to reproduce.
> Now we have a patch to try to revert if/when we finally get a reproducible
> case.

It seems very unlikely that the echo has anything to do with it, other
than making the problem more visible.  See this post:

	http://marc.info/?l=linux-kernel&m=121526224222656&w=2

And to what patch of yours are you referring?

				-Joe

