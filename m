Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZAFM7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZAFM7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZAFM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:59:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2772 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZAFM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:59:07 -0500
Date: Tue, 6 Jan 2009 12:58:59 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: dbrownell@users.sourceforge.net
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090106125858.GE6783@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <200901051545.04912.david-b@pacbell.net> <20090106101050.GB6783@sirena.org.uk> <200901060221.26614.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901060221.26614.david-b@pacbell.net>
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

On Tue, Jan 06, 2009 at 02:21:26AM -0800, David Brownell wrote:
> On Tuesday 06 January 2009, Mark Brown wrote:

> >	[ Long URL for your i.MX3 cpufreq driver elided ] 

> Right, and what's keeping you from providing a "struct device *"
> for that to use?

Well, clearly it can be done but I'd expect review issues from having
the architectures provide a half done representation of the CPU in the
device tree that's essentially private to the cpufreq driver (and then
has no tie in with cpufreq itself).

Personally, I'd be much happier to require a device if there were some
agreement about how CPUs should be done in the device model - at the
minute it all seems very ad-hoc where it's done at all.  For the time
being I'd prefer to bodge in a device for doing printouts in the
regulator core rather than forcing users to have a device when we don't
have a clear story on what to use.  Neither approach is particularly nice.
