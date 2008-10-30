Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYJ3UR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYJ3UR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYJ3URR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:17:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4565 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYJ3URR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:17:17 -0400
Date: Thu, 30 Oct 2008 20:08:54 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20081030200851.GC13678@sirena.org.uk>
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] API for system clocks (oscillators)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 03:41:17PM +0100, Jonas Bonn wrote:

> I'd be happy to get some feedback on this, whether or not it is a good
> idea or even the right way to approach this problem.  This is part of

Something like this would certainly be very useful for audio clocking if
it could be made to fit - that can get complex, is partly off-SoC and
frequently has multiple interrelated clock sources available, often with
various hard to describe interdependencies with constraints coming from
multiple sources and changing dynamically at run time.

In general your problem statement looks fairly sane.  I've not reviewed
this in detail but do think you should have a look at the OMAP stuff.

One thing to watch out for is that you'll find clocks doing things like
originating in one chip, going through another and being fed back into
the original chip.
