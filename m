Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZCaKzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZCaKzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZCaKzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:55:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41619 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZCaKzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:55:32 -0400
Date: Tue, 31 Mar 2009 11:55:28 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Liam Girdwood <lrg@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: regulator: Add disable_on_boot flag to constraints.
Message-ID: <20090331105528.GA16255@sirena.org.uk>
References: <4975BE69.5040106@cam.ac.uk> <20090120124338.GA31521@sirena.org.uk> <4975CAF5.9090607@cam.ac.uk> <4975CF70.5080802@gmail.com> <1232482483.16911.299.camel@vega.slimlogic.co.uk> <497734D3.4090207@cam.ac.uk> <49CFCB44.1080608@gmail.com> <20090330095245.GB31781@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330095245.GB31781@sirena.org.uk>
X-Cookie: You are lost in the Swamps of Despair.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:52:45AM +0100, Mark Brown wrote:

> I'm happy with it but it does need redoing against the current regulator
> branch.  Might be worth renaming the option to disable_immediately or
> something, though.

BTW, note that the regulator API has gained the ability to power off
unused regulators in late_initcall() if the board requests this via
regulator_has_full_constraints() (which will become the default at some
point).  The ability to turn off immediately when applying the
constraints would still be useful, though.
