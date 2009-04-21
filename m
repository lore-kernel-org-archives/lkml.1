Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZDUKFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZDUKFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZDUKF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:05:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48747 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZDUKFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:05:25 -0400
Date: Tue, 21 Apr 2009 11:05:24 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: James Kosin <jkosin@beta.intcomgrp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090421100524.GC25828@sirena.org.uk>
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC9709.8070002@support.intcomgrp.com>
X-Cookie: Rubber bands have snappy endings!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 11:38:49AM -0400, James Kosin wrote:

> > such as GPS trancievers and GSM modems. Moreover, in SoC based systems it is
> > possible to switch on/off power to entire subsystem when it is not used.

> I'd also ask the question, Why?
> If exposing to user space it leaves the possibility of damaging hardware
> or completely frying a board.

There are some classes of device found in embedded systems which do
things like provide an essentially separate system which interacts with
the host system via something like a serial port.  These devices are
normally controlled entirely from user space which is fine with static
power configuration but if you want to provide regulator control for
these devices you need to either move the control of the device into the
kernel or expose the regulators the device uses to userspace.
