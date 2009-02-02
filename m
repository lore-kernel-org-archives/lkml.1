Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZBBLm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZBBLm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZBBLmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:42:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4214 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBBLmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:42:19 -0500
Date: Mon, 2 Feb 2009 11:42:16 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: Improve diagnostics for WM8350 ID register probe
Message-ID: <20090202114215.GA19282@sirena.org.uk>
References: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1232727516-5049-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1232727516-5049-3-git-send-email-broonie@opensource.wolfsonmicro.com> <20090130121009.6de9f11c.akpm@linux-foundation.org> <20090202110013.GA16510@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202110013.GA16510@sirena.org.uk>
X-Cookie: Hackers of the world, unite!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 11:00:17AM +0000, Mark Brown wrote:
> On Fri, Jan 30, 2009 at 12:10:09PM -0800, Andrew Morton wrote:

> > Reading a bunch of bytes into a u16 looks a bit fishy from the endianness
> > point of view?

> Hrm, yeah.  I'll send a patch for this.  Shouldn't be an issue in
> practice since this is a primary PMIC and is unlikely to be used to
> power anything with the wrong endianness.

...or not, the code is already OK.  The next block of code uses
be16_to_cpu() on all the values before they're actually used.
