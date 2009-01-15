Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZAOMu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZAOMu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZAOMus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:50:48 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:38742 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbZAOMur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:50:47 -0500
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
In-Reply-To: <20090115124007.GD2147@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net>
	 <200811161458.17212.david-b@pacbell.net>
	 <20081117015127.GA10883@sirena.org.uk>
	 <200901142303.17906.david-b@pacbell.net>
	 <20090115124007.GD2147@sirena.org.uk>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 12:50:45 +0000
Message-Id: <1232023845.4934.368.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 12:40 +0000, Mark Brown wrote:

> but...
> 
> > +enum regulator_status {
> > +	REGULATOR_STATUS_OFF,
> > +	REGULATOR_STATUS_ON,
> > +	REGULATOR_STATUS_ERROR,
> > +	/* fast/normal/idle/standby are flavors of "on" */
> > +	REGULATOR_STATUS_FAST,
> > +	REGULATOR_STATUS_NORMAL,
> > +	REGULATOR_STATUS_IDLE,
> > +	REGULATOR_STATUS_STANDBY,
> > +};
> > +
> 
> > +	/* report regulator status ... most other accessors report
> > +	 * control inputs, this reports results of combining inputs
> > +	 * from Linux (and other sources) with the actual load.
> > +	 */
> > +	int (*get_status)(struct regulator_dev *);
> > +
> 
> ...this needs kerneldoc adding.

Please send a separate patch for the kerneldoc as I've already applied.

Thanks

Liam

