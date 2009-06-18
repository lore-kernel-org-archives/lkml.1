Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZFRLBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZFRLBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZFRLBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:01:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZFRLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:01:04 -0400
Date: Thu, 18 Jun 2009 12:00:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Message-ID: <20090618110050.GA14118@sirena.org.uk>
References: <1245257799-29752-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1245322443.21421.254.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245322443.21421.254.camel@vega.slimlogic.co.uk>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Allow consumer supplies to be set up with
	dev_name()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 11:54:03AM +0100, Liam Girdwood wrote:
> On Wed, 2009-06-17 at 17:56 +0100, Mark Brown wrote:

> > In order to avoid making existing machines instabuggy and creating merge
> > issues the use of struct device is still supported for the time being.

> We should probably mark this as deprecated in the docs.

Yeah, probably.  I was swithering a bit since while obviously it doesn't
work so well for things like I2C when you do have the struct device
there it's pretty convenient to use it, but having both ways to specify
it makes things more confusing than they need to be.
