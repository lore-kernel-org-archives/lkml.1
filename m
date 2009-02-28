Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZB1P67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZB1P67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 10:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZB1P6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 10:58:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1805 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZB1P6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 10:58:50 -0500
Date: Sat, 28 Feb 2009 15:58:42 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <20090228155841.GA15127@sirena.org.uk>
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A942F6.3020600@s5r6.in-berlin.de>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 02:58:14PM +0100, Stefan Richter wrote:

> This gives false positives for patches like this:

> From: [...]
> Subject: this single line fully explains the whole patch

> Signed-off-by: [...]

That's not a false postive, that's exactly the case it's intended to
catch.  People like Andrew Morton complain because there's no text in
the actual body of the email (as well as because some of the patches
that do this could probably use a bit more explanation).
