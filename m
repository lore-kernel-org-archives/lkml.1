Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZDYJFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZDYJFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 05:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZDYJFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 05:05:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35234 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZDYJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 05:05:03 -0400
Date: Sat, 25 Apr 2009 10:04:49 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Rapoport <mike@compulab.co.il>,
       James Kosin <jkosin@beta.intcomgrp.com>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Message-ID: <20090425090448.GA4210@sirena.org.uk>
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com> <49EDD2A7.9090300@compulab.co.il> <20090425081933.GE2428@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425081933.GE2428@ucw.cz>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFD] voltage/current regulator consumer interface
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:19:33AM +0200, Pavel Machek wrote:

> Well, then you should teach serial driver to power the (GPS) device up on
> open() and power it off on close()...

This all started because this approach was nacked for serial drivers.
In any case, I'm not sure that'll scale - it may not be desirable or
reasonable to do something like that for all devices.  For example, the
devices may be connected via a technology that's not suitable (I've
worked on systems which used ethernet here).
