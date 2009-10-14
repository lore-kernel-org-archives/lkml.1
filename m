Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbZJNMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbZJNMxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbZJNMxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:53:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59006 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854AbZJNMxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:53:47 -0400
Date: Wed, 14 Oct 2009 13:53:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Message-ID: <20091014125303.GD24540@sirena.org.uk>
References: <20091010134814.0bac8624@bike.lwn.net> <200910131410.40305.david-b@pacbell.net> <20091013162819.02f53284@bike.lwn.net> <200910131553.58804.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910131553.58804.david-b@pacbell.net>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:53:58PM -0700, David Brownell wrote:
> On Tuesday 13 October 2009, Jonathan Corbet wrote:

> > (I'm less worried about the uniqueness side, BTW; it just means drivers
> > need to create meaningful names for their GPIOs.)

> I don't see how they *can* though ... unless they're dynamically
> allocated using a scheme like "combine <this device's sysfs name>
> with <token>".  Consider two PCI cards with two different GPIOs
> for their "camera_active" LED... "camera_active" is meaningful,
> but unusable because it's not unique.

I guess the clock API style dev/dev_name based deduping would do the job
here, though that's a separate question from the general usefulness of
this sort of lookup framework.
