Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZHIKvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZHIKvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZHIKvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:51:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48984 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZHIKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:51:23 -0400
Date: Sun, 9 Aug 2009 11:51:13 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Message-ID: <20090809105112.GD4773@sirena.org.uk>
References: <20090807180941.GF1728@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807180941.GF1728@ucw.cz>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: ads7846: clean up, fix pressure reporting
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 08:09:41PM +0200, Pavel Machek wrote:

> +#ifndef VERBOSE
> +#undef dev_dbg
> +#define dev_dbg(...) do {} while(0)
> +#endif

Better to convert the offending dev_dbg()s to dev_vdbg() instead, I'd
have thought.
