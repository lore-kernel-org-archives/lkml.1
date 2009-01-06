Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZAFKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZAFKLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZAFKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:10:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1116 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZAFKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:10:58 -0500
Date: Tue, 6 Jan 2009 10:10:51 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090106101050.GB6783@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <200812012150.36342.david-b@pacbell.net> <20081202133228.GD7940@sirena.org.uk> <200901051545.04912.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051545.04912.david-b@pacbell.net>
X-Cookie: The Ranger isn't gonna like it, Yogi.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 03:45:04PM -0800, David Brownell wrote:

> When someone writes a cpufreq driver that uses the
> regulator framework, they can arrange to provide the
> relevant "struct device *" to make that work neatly.

I'm fairly sure it's been mentioned before but there's some already, for
example:

http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-audioplus.git;a=blob;f=arch/arm/mach-mx3/cpufreq.c;h=7a2d5154ada5fb58aeb49b261e6f08cb591b96b2;hb=refs/heads/imx31

Actually, I have some updates to that I should push, needs to be
disentangled from some other stuff first.
