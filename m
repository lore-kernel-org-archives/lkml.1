Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYKTI04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYKTI04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYKTI0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:26:47 -0500
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:43466 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYKTI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:26:47 -0500
Date: Thu, 20 Nov 2008 08:26:39 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>
Subject: Re: gitwatch: RSS feed of checkpatch+coccinelle against new
	commits in mainline
Message-ID: <20081120082639.GC14274@shadowen.org>
References: <19f34abd0811181420i2b582fd2jcaa685b0cbb5c979@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0811181420i2b582fd2jcaa685b0cbb5c979@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 11:20:48PM +0100, Vegard Nossum wrote:
> Hi,
> 
> I've written a script that follows the mainline git repository and
> runs checkpatch against all new commits. The result is available as an
> RSS stream:
> 
>     http://kernel.org/~vegard/gitwatch.rss
> 
> Only commits with warnings or errors are shown. Files that change are
> also searched for known/frequent coding errors using Coccinelle and a
> selection of the semantic patches found on the Coccinelle website.

Thats pretty intresting.  Looking at some of the cochinelle output I am
a little confused as to what its saying.  Am I right in thinking that
for those reports that a proposed patch is printed, after the comment
for the original patch?  If so it might be helpful to say something like
'proposed modificiation' just before the patchlet.

Also which version of checkpatch is this output being generated with?
The one at the head of the git tree or something else?  I see a couple
of false positives in there that I know I have fixed already.

-apw
