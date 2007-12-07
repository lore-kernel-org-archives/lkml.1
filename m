Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbXLGEmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbXLGEmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXLGEmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:42:32 -0500
Received: from [212.12.190.105] ([212.12.190.105]:40442 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752973AbXLGEmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:42:31 -0500
From: Al Boldi <a1426z@gawab.com>
To: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Subject: Re: git guidance
Date: Fri, 7 Dec 2007 07:37:18 +0300
User-Agent: KMail/1.5
Cc: Andreas Ericsson <ae@op5.se>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712072155.04643.a1426z@gawab.com> <Pine.LNX.4.64.0712062119090.21625@wbgn129.biozentrum.uni-wuerzburg.de>
In-Reply-To: <Pine.LNX.4.64.0712062119090.21625@wbgn129.biozentrum.uni-wuerzburg.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712070737.18519.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Schindelin wrote:
> Hi,

Hi

> On Fri, 7 Dec 2007, Al Boldi wrote:
> > You need to re-read the thread.
>
> I don't know why you write that, and then say thanks.  Clearly, what you
> wrote originally, and what Andreas pointed out, were quite obvious
> indicators that git already does what you suggest.
>
> You _do_ work "transparently" (whatever you understand by that overused
> term) in the working directory, unimpeded by git.

If you go back in the thread, you may find a link to a gitfs client that 
somebody kindly posted.  This client pretty much defines the transparency 
I'm talking about.  The only problem is that it's read-only.

To make it really useful, it has to support versioning locally, disconnected 
from the server repository.  One way to implement this, could be by 
committing every update unconditionally to an on-the-fly created git 
repository private to the gitfs client.

With this transparently created private scratch repository it should then be 
possible for the same gitfs to re-expose the locally created commits, all 
without any direct user-intervention.

Later, this same scratch repository could then be managed by the normal 
git-management tools/commands to ultimately update the backend git 
repositories.

BTW:  Sorry for my previous posts that contained the wrong date; it seems 
that hibernation sometimes advances the date by a full 24h.  Has anybody 
noticed this as well?


Thanks!

--
Al

