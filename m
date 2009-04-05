Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZDESw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZDESw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZDESwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:52:20 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47853 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZDESwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:52:19 -0400
Date: Sun, 5 Apr 2009 19:51:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Chris Friesen <cfriesen@nortel.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, peterz@infradead.org,
       akpm@linux-foundation.org
Subject: Re: Resend: /proc/<pid>/maps offset output broken in 2.6.29
In-Reply-To: <49D523FB.2020504@nortel.com>
Message-ID: <Pine.LNX.4.64.0904051944100.27448@blonde.anvils>
References: <49CA8501.1000000@nortel.com>  <49D3F662.4050100@nortel.com>
 <1238659491.9041.133.camel@localhost> <Pine.LNX.4.64.0904021324070.16207@blonde.anvils>
 <49D4FB89.4070101@nortel.com> <Pine.LNX.4.64.0904021938270.25731@blonde.anvils>
 <49D523FB.2020504@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Chris Friesen wrote:
> Hugh Dickins wrote:
> 
> > This is a cosmetic matter, not worth more than a couple of lines of
> > code: I suggested masking off the high bits in the display, but when
> > KAMEZAWA-san suggested just showing 0, it was hard to argue against
> > his brutal simplicity.
> 
> <snip>
> 
> > Consider this change a fix: it used to show 00000000 before 2.6.7.
> > 
> > See http://lkml.org/lkml/2009/1/13/331 for one of the threads
> > on the subject - but you've not tempted me to reopen it!
> 
> Okay, fair enough.  I'll change my code to deal with it.  Thanks for the
> explanation.

Oh, I thought you were arguing hypotheticals.  This is more serious,
that you have some userspace code which depended on the 2.6.8-2.6.29
way of filling that field, and now we're about to break it.

Please, would you share what you were doing with the vm_pgoff of an
anonymous area?  I won't pretend: I am indeed hoping to show that
what you were doing before was already broken, so that we can safely
go ahead and break it some more!

Hugh
