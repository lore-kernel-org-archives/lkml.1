Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbZAONCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbZAONCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZAONCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:02:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4362 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZAONCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:02:39 -0500
Date: Thu, 15 Jan 2009 13:02:32 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@openedhand.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within mfd driver.
Message-ID: <20090115130230.GG2147@sirena.org.uk>
References: <496E2BE5.1050803@cam.ac.uk> <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com> <496ED8F6.6030201@compulab.co.il> <f17812d70901142302n53953607o124df5601cd037bc@mail.gmail.com> <496EE5A4.4010805@compulab.co.il> <f17812d70901150013v2c70047er829b1c884a1d7772@mail.gmail.com> <496F1C7A.5080202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F1C7A.5080202@gmail.com>
X-Cookie: <rcw> liiwi: printk("CPU0 on fire
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

")
Fcc: +sent-mail

On Thu, Jan 15, 2009 at 11:22:34AM +0000, Jonathan Cameron wrote:

> > I would expect the final solution to be clean enough, that requires some
> > dependent stuffs to be modified, and the final look of this patch may be a
> > bit different

> Agreed.  This definitely isn't the way to go in the long run (assuming
> otg etc get cleaned up)
> but would it be an acceptable stop gap?  I'm just keen to get the
> functionality available
> so as to get a board config (intel stargate 2) sorted.  (some of which
> you were kind enough to
> review a while back - thanks).

Having looked at this problem just this week for some other designs I'm
thinking the regulator API might be a good fit for this.  It is a supply
and the API provides a method to match up the supply with the USB
controller (some designs have multiple options there so that's useful).
I've not actually tried it yet to see what the pain is like, though.
