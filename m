Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZK0LG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZK0LG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZK0LG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:06:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43528 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZK0LG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:06:58 -0500
Date: Fri, 27 Nov 2009 11:06:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <damm@igel.co.jp>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/2 v2] ASoC: sh: fsi: Add runtime PM
	support
Message-ID: <20091127110656.GA29512@sirena.org.uk>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <20091109105858.GB1245@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109105858.GB1245@sirena.org.uk>
X-Cookie: Sorry.  Nice try.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 10:58:58AM +0000, Mark Brown wrote:
> On Mon, Nov 09, 2009 at 11:54:47AM +0900, Kuninori Morimoto wrote:

> > +	pm_suspend_ignore_children(&pdev->dev, true);
> > +	pm_runtime_enable(&pdev->dev);
> > +	pm_runtime_resume(&pdev->dev);

> Why pm_suspend_ignore_all_children()?  I'd not expect the device to have
> any children and if it did it doesn't seem like an entirely safe
> assumption.

I've not yet seen any response to this query?
