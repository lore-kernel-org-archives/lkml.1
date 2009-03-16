Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbZCPVys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbZCPVys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbZCPVyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:54:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1796 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762167AbZCPVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:54:35 -0400
Date: Mon, 16 Mar 2009 21:54:23 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090316215422.GA6433@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903141725.35541.david-b@pacbell.net> <20090315003743.GB11052@sirena.org.uk> <200903142105.29382.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903142105.29382.david-b@pacbell.net>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 09:05:29PM -0700, David Brownell wrote:

> was called.  It's not exactly hard to check if it was enabled, then
> act accordingly, in the typical "single consumer of the regulator"
> case.

How typical that is depends very much on the devices you're looking at.
Devices that need to do things like set voltages are fairly likely to
own the regulator but with devices that just need to ensure that they
have their supplies enabled it's much more likely that the supplies will
be shared.
