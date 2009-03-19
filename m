Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZCST1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZCST1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZCST1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:27:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39280 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZCST1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:27:19 -0400
Date: Thu, 19 Mar 2009 19:27:11 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090319192711.GC8966@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903181225.11444.david-b@pacbell.net> <20090318203317.GA6299@sirena.org.uk> <200903181402.14384.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903181402.14384.david-b@pacbell.net>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 02:02:14PM -0700, David Brownell wrote:

> Huh?  $SUBJECT patch hasn't merged.  How could you
> have backed it out??

Sorry - another patch introducing a version of the same issue.  Your
patch:

http://git.kernel.org/?p=linux/kernel/git/lrg/voltage-2.6.git;a=commit;h=67130ef073299cc7299d3ffa344122959e97753c

bumped the refcount for boot_on regulators.  This patch:

http://git.kernel.org/?p=linux/kernel/git/lrg/voltage-2.6.git;a=commit;h=504e7d7e42fb3a58809946770ff5e07cc9d52dbf

backs out that change only.  This was my bad on the review.
