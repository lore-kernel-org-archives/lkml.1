Return-Path: <linux-kernel-owner+w=401wt.eu-S934824AbYEIBLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbYEIBLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbYEIBLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:11:20 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:34172 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYEIBLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:11:18 -0400
Message-ID: <4823A503.8090102@keyaccess.nl>
Date: Fri, 09 May 2008 03:12:35 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Ken Moffat <zarniwhoop@ntlworld.com>, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT bisection range errors
References: <48237CA0.4080001@keyaccess.nl>	<20080508222545.GH22887@cs181133002.pp.htv.fi>	<48238087.7000509@keyaccess.nl> <20080508225645.GA24725@deepthought> <adave1oqslr.fsf@cisco.com>
In-Reply-To: <adave1oqslr.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-05-08 01:33, Roland Dreier wrote:

> This is normal and expected, due to the distributed nature of git and
> the fact that git-bisect operates on the full topology of history and
> not just a linear sequence of commits.
> 
> Imagine history like:
> 
>     A---B---C---D
>      \         /
>       \       /
>        \     /
>         E---F
> 
> where B is good and D is bad.  Now, when you bisect, there is no way to
> know whether, say, E is good or bad and hence the bisect process may
> present E as a tree to try.
> 
> Now, if B is the 2.6.25 release, then since E branched off before B, it
> will have a Makefile that says 2.6.25-rcX.  Which is exactly the
> behavior you are seeing.
> 
> In short, everything looks fine and is behaving as expected.

Great explanation. Thanks.

Rene
