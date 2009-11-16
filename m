Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZKPVeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZKPVeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZKPVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:34:08 -0500
Received: from bar.sig21.net ([80.81.252.164]:42539 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZKPVeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:34:07 -0500
Date: Mon, 16 Nov 2009 22:34:25 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: atkbd - add forced release kays quirk for
 Samsung N130
Message-ID: <20091116213425.GA2128@sig21.net>
References: <20091116171814.GA26183@sig21.net>
 <20091116195443.GE24026@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116195443.GE24026@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.801,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, Nov 16, 2009 at 11:54:43AM -0800, Dmitry Torokhov wrote:
> On Mon, Nov 16, 2009 at 06:18:14PM +0100, Johannes Stezenbach wrote:
> > Samsung N130 has the same function key quirks as the NC10.
> > 
> > Signed-off-by: Johannes Stezenbach <js@sig21.net>
> > ---
> > It would be nice if this could go into 2.6.32.  It might also be
> > suitable for stable.
> 
> 2.6.32 will allow manipulating force release quirk from userspace
> (sysfs) so I stopped accepting in-kernel quirks like this one.

OK, makes sense.  Will this be put in udev along with
the keymap setup for the function keys?  If yes, is
there already an example how to do it correctly so 
I can submit a patch to add the N130 support there?


Thanks
Johannes
