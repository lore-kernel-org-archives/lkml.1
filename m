Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbZAOQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbZAOQFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZAOQF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:05:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4686 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbZAOQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:05:25 -0500
Date: Thu, 15 Jan 2009 16:05:21 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
Message-ID: <20090115160517.GA12768@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <20090115124007.GD2147@sirena.org.uk> <1232023845.4934.368.camel@vega.slimlogic.co.uk> <200901150735.29883.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901150735.29883.david-b@pacbell.net>
X-Cookie: I will not forget you.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 07:35:29AM -0800, David Brownell wrote:
> On Thursday 15 January 2009, Liam Girdwood wrote:

> > Please send a separate patch for the kerneldoc as I've already applied.

> So that will be the first member of "struct regulator_ops" to
> grow kerneldoc ... out of a total of fifteen (now) members.
> Hmm...

> Maybe I'm not understanding what's meant by "kerneldoc adding".
> Perhaps it's nothing more than a sentence resembling "returns
> REGULATOR_STATUS_* code or negative errno", and not real
> kerneldoc?

No, real kerneldoc - this was added recently, check current mainline
(eg, commit c8e7e4640facbe99d10a6e262523b25be129b9b9).  I'm not saying
it's great but it's there.

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
