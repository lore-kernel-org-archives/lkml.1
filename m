Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZGYLYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZGYLYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 07:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZGYLYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 07:24:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33416 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZGYLYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 07:24:06 -0400
Date: Sat, 25 Jul 2009 12:23:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20090725112359.GB4600@sirena.org.uk>
References: <1246550798-9936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090713113017.GB24783@sirena.org.uk>
 <20090724223554.GA10055@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724223554.GA10055@sortiz.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC] mfd: Allow multiple MFD cells with the same name
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 12:35:55AM +0200, Samuel Ortiz wrote:
> On Mon, Jul 13, 2009 at 12:30:18PM +0100, Mark Brown wrote:

> > Samuel, do you have any thoughts on this patch?  As I said...

> I think it's safe to expect people that decide they need this feature will be
> careful enough to make sure they dont get ID collisions.

Yes, and it should be fairly easy to work out what's gone wrong if there
are any problems.

> > ...but it'd be really helpful to get some idea if this approach is going
> > to be viable for some code I'm currently working on.

> I'm ok with this patch, but I'd like the new cell->id field to be more
> documented. In particular we should mention that one should leave it to 0
> unless trying to add several cells of the same type.
> I'll push this patch once I'll be back from vacation, thanks.

OK, thanks.  I'm not sure when you're back from your vacation but early
next week I should be releasing the code which I was mentioning above -
if you've not applied it before then I'll try to include a revised
version with more documentation in that series.
