Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZGALqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZGALqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZGALqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:46:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32798 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751549AbZGALqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:46:03 -0400
Date: Wed, 1 Jul 2009 12:46:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.y.miao@gmail.com>, Daniel Ribeiro <drwyrm@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
Message-ID: <20090701114603.GA22063@rakim.wolfsonmicro.main>
References: <1246057668.10360.316.camel@brutus>
 <4A482E56.1070604@gmail.com>
 <20090629094311.GD11855@sirena.org.uk>
 <200906301936.20818.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906301936.20818.david-b@pacbell.net>
X-Cookie: Many a family tree needs trimming.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 07:36:20PM -0700, David Brownell wrote:
> On Monday 29 June 2009, Mark Brown wrote:

> > At the minute the regulator API actually copes pretty well with this -
> > the only problem I'm aware of is with drivers like the MMC driver which
> > require exclusive control of the regulator.

> Which is a fairly typical situation for power-aware drivers.

As has been mentioned a number of times in previous discussions of this
there is a very large class of devices which do not *require* any power
control at all but which can usefully switch their supplies on and off.

> Which belies your claim that the regulator API "copes pretty well".
> It'd be more accurate to say "broken-as-designed", since you have
> rejected numerous attempts to fix this, yet not fixed it yourself.

You've suggested variations of essentially one approach, forcing the
regulator to be off while the use count is zero.  In response to this
you've not only been given explanations of the problems this causes but
also several suggestions for alternative approaches such as adding a way
to request exclusive use of the regulator or adding something in
constraints to turn off the regulator at startup.

I have previously had to ask you to try to approach discussions on the
regulator API in a more constructive fashion, please let me renew that
request.  Doing so would be much less time consuming and for that reason
if nothing else would be very helpful in progressing things.
