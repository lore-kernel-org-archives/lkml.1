Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZFYNQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZFYNQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZFYNQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:16:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60414 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbZFYNQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:16:30 -0400
Date: Thu, 25 Jun 2009 14:16:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Message-ID: <20090625131625.GC17690@sirena.org.uk>
References: <1245257799-29752-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4A437792.6040009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A437792.6040009@gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Allow consumer supplies to be set up with
 dev_name()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 01:11:46PM +0000, Jonathan Cameron wrote:

> I just wonder if we need to suggest subsystem maintainers make sure that
> their
> device names are suitably unique and identifiable?  For example, i2c device
> tend to have names like 0-0032.  Perhaps we need something to identify
> that they
> are indeed i2c devices?

Either that or if it becomes a problem we add the ability to match on
bus type as well - since bus type already exists it'd probably be better
to go down that road rather than cause userspace-visible changes.  I've
not looked in sufficient detail to confirm that this would cover
everything but I believe it should.

> For that matter, is there anything other than blind luck preventing two
> regulator
> consumers having the same dev_name?

Due to sysfs requirements I think we should be safe with the addition of
bus type matching but like I say I may be missing something.
