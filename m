Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYJ3UOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYJ3UOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYJ3UN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:13:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4555 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYJ3UN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:13:58 -0400
Date: Thu, 30 Oct 2008 20:13:44 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20081030201341.GD13678@sirena.org.uk>
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com> <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com> <7a6abd110810300927l428b11f3u509ad31364c08f1f@mail.gmail.com> <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com> <7a6abd110810301001r7fc311adifd85fece79cb5c45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a6abd110810301001r7fc311adifd85fece79cb5c45@mail.gmail.com>
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

On Thu, Oct 30, 2008 at 06:01:42PM +0100, Jonas Bonn wrote:

> > You could probably work those features into the existing clk framework.
> > clk_set_rate() could compute the constrains and return an error.
> > The API could be expanded with notifier support.

...

> What drove me to document a new interface is the fact that there are
> so many users of "struct clk" already, that it becomes conceptually
> easier to dream up something new that stays out of the way, even if
> that new  thing becomes just a wrapper around the existing interface

BTW, on this point I don't know if you've seen Dmitry Baryshkov's work
on a generic implementation of the existing clk API.
