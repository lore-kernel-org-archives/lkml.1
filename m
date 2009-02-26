Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZBZKql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZBZKql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZBZKqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:46:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1106 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZBZKqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:46:30 -0500
Date: Thu, 26 Feb 2009 10:46:27 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Message-ID: <20090226104624.GA4229@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902241617.22643.david-b@pacbell.net> <20090225151721.GA31637@sirena.org.uk> <200902251702.03230.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902251702.03230.david-b@pacbell.net>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:02:03PM -0800, David Brownell wrote:

> Oh, one more comment.  Requiring manual configuration
> of fixed-voltage regulators is pure time-wastage.

Unless, of course, you happen to be using one of those consumers that
wants to know the voltage it's running at to configure itself.  Examples
I've seen include sensors and analogue components which can be
configured for better performance if they know the voltage they run at -
and yes, people do run these things off regulators that they vary at
runtime.

If you want to submit a patch making it optional that's fine.
