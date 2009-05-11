Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZEKMXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZEKMXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZEKMXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:23:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58851 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbZEKMXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:23:19 -0400
Date: Mon, 11 May 2009 13:23:19 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: ???? <wxc200@gmail.com>, linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error
	report
Message-ID: <20090511122319.GB20283@sirena.org.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> <20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk> <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com> <Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk> <20090511112801.GA20283@sirena.org.uk> <Pine.LNX.4.64.0905111314450.30347@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905111314450.30347@venus.araneidae.co.uk>
X-Cookie: Life is like a simile.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 01:16:38PM +0100, Michael Abbott wrote:

> However, then, does it make sense for the PXA i2c bus prober to be calling 
> the "scream blue murder" routine in this frankly routine case?  I guess it 
> could just say "no device found at address xx"

You should really convert your board to specify explicitly which chips
are on the board rather than using the old style probe routines.
