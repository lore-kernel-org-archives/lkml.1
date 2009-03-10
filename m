Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZCJV1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZCJV1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZCJV1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:27:43 -0400
Received: from ping.pong.ch ([212.103.71.101]:39442 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbZCJV1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:27:42 -0400
Date: Tue, 10 Mar 2009 22:27:37 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
	breaks resume from RAM on PowerBook
Message-ID: <20090310212737.GA6272@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch> <20090306114149.GA5371@soziologie.ch> <1236638264.7260.192.camel@pasglop> <200903101032.58617.rjw@sisk.pl> <20090310150126.GB5633@soziologie.ch> <1236718726.7086.11.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236718726.7086.11.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 07:58:46AM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2009-03-10 at 16:01 +0100, Gaudenz Steinlin wrote:
> > Hi Rafael
> > 
> > On Tue, Mar 10, 2009 at 10:32:58AM +0100, Rafael J. Wysocki wrote:
> > > 
> > > Gaudenz, I'd also like to know if the appended patch (on top of vanilla Linus'
> > > tree) makes any different.  Unfortunately, I haven't had the time to test it
> > > myself yet.
> > 
> > No, this patch does not make any difference.
> 
> What about the one I sent you that removes the early wakeup ?

Sorry, I first tested Rafaels patch. I now also found the time to test
your patch and it works. With this patch on top of todays Linus tree,
the resume problem is gone.

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
