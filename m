Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0BWDR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 22:17:26 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:55574 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0BWDRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 22:17:24 -0500
Date: Mon, 22 Feb 2010 22:17:06 -0500 (EST)
From: Ari Entlich <atrigent@ccs.neu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <21495088.197211266895026487.JavaMail.root@zimbra>
In-Reply-To: <8748337.196941266894473447.JavaMail.root@zimbra>
Subject: Re: [PATCH v2] Add a new VT mode which is like VT_PROCESS but
 doesn't require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.10.223.210]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Andrew Morton" <akpm@linux-foundation.org> wrote:
> Well, it "should" become easier, but does it?  Has anyone patched their
> X server to confirm that this kernel change improves things?  I'm
> wondering how this change was tested?

Haha yeah, that's a very good point. I put a note in the first version of this patch that it had been compile tested only... I probably should have put the note in the second version as well. It would probably be a good idea to hold off on committing this anywhere until I actually get it working with X. In fact, maybe it would even be best for you to back it out of the mm tree until it's been "proven", at which point I'll resubmit the patch.

> Is there a plan to get the X server modified to use VT_PROCESS_AUTO?

I am now actively working on that.

Also, sorry about the code style issues. I'm a bit of a noob at this. I will include the style fixes in the next version of the patch.

Ari
