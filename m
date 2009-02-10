Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZBJPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZBJPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZBJPTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:19:11 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4839 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZBJPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:19:09 -0500
Date: Tue, 10 Feb 2009 15:19:03 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
Cc: David Brownell <david-b@pacbell.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc3-git 2/2] USB: disable twl4030 USB regulators when cable unplugged
Message-ID: <20090210151902.GA31365@sirena.org.uk>
References: <200902081053.00255.david-b@pacbell.net> <1234271294.17391.12.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234271294.17391.12.camel@ubuntu>
X-Cookie: To the landlord belongs the doorknobs.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 03:08:14PM +0200, Kalle Jokiniemi wrote:

> A bug has been discovered here. If the twl-regulator is not compiled in,
> the twl4030-usb fails while trying to access the reg-fw interfaces (and

reg-fw is the regulator framework?

> not checking error values). Also it's bit confusing how we get different
> error values if reg_fw is not compiled (no error) vs. reg_fw is
> compiled, but twl_regulator is not... (error)

The general model is that if you've got regulator API support enabled
then you'll have the relevant regulator drivers enabled.  The support
for compiling out the core is intended to allow configurations that
don't use regulators at all.  This is a bit restrictive but works well
for most users.
