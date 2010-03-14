Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0CNUJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:09:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49738 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0CNUJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:09:28 -0400
Date: Sun, 14 Mar 2010 20:09:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
       dbrownell@users.sourceforge.net
Message-ID: <20100314200923.GA3051@sirena.org.uk>
References: <20100312172156.GB22822@rakim.wolfsonmicro.main>
 <c9b72e72ecf154ff6bf96bd956bef7d4c5aca2d4.1268417170.git.ameya.palande@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9b72e72ecf154ff6bf96bd956bef7d4c5aca2d4.1268417170.git.ameya.palande@nokia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] regulator: Get rid of lockdep warning
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 08:09:01PM +0200, Ameya Palande wrote:
> From: Ameya Palande <ameya.palande@nokia.com>
> 
> WARNING: at kernel/lockdep.c:2706 sysfs_add_file_mode+0x4c/0xa8()
> 
> Difference between v1 and v2:
> Moved sysfs_attr_init() call as first one to access the structure.
> 
> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
> CC: Liam Girdwood <lrg@slimlogic.co.uk>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> CC: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
