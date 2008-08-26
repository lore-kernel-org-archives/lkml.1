Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYHZHky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYHZHky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYHZHkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:40:43 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:58046 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYHZHkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:40:42 -0400
Message-ID: <48B3B375.8050407@davidnewall.com>
Date: Tue, 26 Aug 2008 17:10:37 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Joe Peterson <joe@skyrush.com>
CC: Willy Tarreau <w@1wt.eu>, Chris Frey <cdfrey@foursquare.net>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Visible Ctrl-C in latest kernels
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu> <48B2EDC2.1020608@davidnewall.com> <48B2F3E9.5020804@skyrush.com> <48B35788.4020008@skyrush.com>
In-Reply-To: <48B35788.4020008@skyrush.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson wrote:
> When I run your program, foreground or background, it always completes
> (i.e. 5 "." chars) - i.e., I cannot interrupt it before it finishes.
>   

This is what should occur and what I originally expected to see.  I
can't explain why it works (slightly) differently on my machine, but
that's probably unimportant.  My thinking is that the issue reported as
^C being delayed could be caused for this sort of reason; it could be a
shell bug, and not a kernel bug.
