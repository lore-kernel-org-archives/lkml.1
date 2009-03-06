Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZCFWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZCFWTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbZCFWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:19:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4373 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZCFWS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:18:59 -0500
Date: Fri, 6 Mar 2009 22:18:43 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, lrg@slimlogic.co.uk,
       LKML <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Message-ID: <20090306221842.GB15728@sirena.org.uk>
References: <49B11EB0.30809@nokia.com> <200903061116.21544.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903061116.21544.david-b@pacbell.net>
X-Cookie: volcano, n.:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 11:16:20AM -0800, David Brownell wrote:

> Do you really need 3.0V out of that regulator?  If so,
> then I'd rather see a patch exposing that CONFIG_*
> setting to enable all the unsupported/out-of-range
> values, rather than just selectively hacking those
> tables to permit some (but not all) of them to be used
> out-of-range.

Would it make sense to make this platform data so that if a given board
requires running the chip like this it can be enabled for those boards
but it's not something people might turn on because it seems useful?
