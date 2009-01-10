Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZAJS6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZAJS6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZAJS6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:58:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4185 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZAJS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:58:40 -0500
Date: Sat, 10 Jan 2009 18:58:31 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>
Message-ID: <20090110185830.GC31525@sirena.org.uk>
References: <4968BE74.1070903@gmail.com> <20090110174602.GA31525@sirena.org.uk> <4968E365.5040409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4968E365.5040409@gmail.com>
X-Cookie: Brain off-line, please wait.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Regulator: Use case query (many devices need to reg their
	voltage requirements?)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 06:05:25PM +0000, Jonathan Cameron wrote:

> It maps fine, particularly as quite a few daughter boards have local (be
> it static)
> regulators to ensure clean supplies etc.

Note that there's a fixed voltage regulator driver in the tree for
handling those.

> >   There will also be issues if the drivers are for chips
> > which have multiple software compatible variants with differing power
> > requirements.

> Yup, though in many cases they have different part numbers etc and can
> be handled via multiple
> driver registrations or alias provisions such as in i2c.  This is how
> things like adc's with differing
> numbers of inputs depending on precise model are handled anyway.

That is doable but error prone, especially if doing something like
adding regulator support to an existing driver or when new parts come
out.  Often the part numbers are only slight different (adding an
additional letter at the end of the day) which doesn't help.
