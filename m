Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYLBKva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYLBKva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYLBKvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:51:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1310 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYLBKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:51:21 -0500
Date: Tue, 2 Dec 2008 10:51:18 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc7] regulator: init/link earlier
Message-ID: <20081202105116.GC7940@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk> <200812012150.13909.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812012150.13909.david-b@pacbell.net>
X-Cookie: Did I do an INCORRECT THING??
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 09:50:13PM -0800, David Brownell wrote:

> The regulator core currently initializes as a core_initcall() to be
> available early ... but then it links way late, throwing away that
> benefit, so regulators available at e.g. subsys_initcall() are not
> available to subsystems which need to use them.

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
