Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYCPP1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYCPP1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 11:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYCPP10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 11:27:26 -0400
Received: from smtp.regionline.fi ([85.157.255.99]:57199 "EHLO
	smtp.regionline.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYCPP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 11:27:25 -0400
From: Jan Knutar <jk-lkml@sci.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Swap makes X unfair (was Re: Keys get stuck)
Date: Sun, 16 Mar 2008 17:27:01 +0200
User-Agent: KMail/1.6.2
Cc: Helge Hafting <helgehaf@mail.aitel.hist.no>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <20080313151354.GA5252@localhost.ift.unesp.br> <47DA5B36.9060209@mail.aitel.hist.no>
In-Reply-To: <47DA5B36.9060209@mail.aitel.hist.no>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803161727.02059.jk-lkml@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2008 13:02, Helge Hafting wrote:

> Normally, memory that is used all the time does not get
> swapped out. If you use X while the machine is swapping,
> you will normally see lots of little delays, not
> one longe freeze.  So this may have been something else.

When it happens to me, the pointer usually updates only about 1 - 2 
times per second, which seems to be enough to cause keyboard repeat 
problems as well.

If the swapfile usage is 0 when a big swapout takes place, I usually see 
about 6M/sec pushed to disc and rarely pointer or keyboard anomalies. 
After running a few more days though, swapping rates drop to 1.3M per 
sec or worse. The delays in X get bigger too, sometimes several seconds 
long. I guess if the kernel swaps out a piece of X that X needs, then 
it takes much much longer to get it back at that low swap rate, and it 
ends up manifesting itself as pointer jitter and keyboard repeat 
problems.

The pointer stutter can be considered acceptable, I guess, atleast there 
the pointer (eventually) jumps to where I expect it to go based on how 
much I move the mouse...

I have to wonder what X is doing to break the keyboard...
