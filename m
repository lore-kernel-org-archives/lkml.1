Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZF3PEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZF3PEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZF3PEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:04:35 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:33927 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZF3PEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:04:34 -0400
Date: Tue, 30 Jun 2009 11:04:30 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
  and use it for olpc driver
Message-ID: <20090630110430.6c7c5cdf@mycelium.queued.net>
In-Reply-To: <20090630113135.GD13961@sirena.org.uk>
References: <20090630021730.44f86185@mycelium.queued.net>
	<20090630113135.GD13961@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 12:31:35 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, Jun 30, 2009 at 02:17:30AM -0400, Andres Salomon wrote:
> 
> > This adds a new sysfs file called 'charge_type' which displays the
> > type of charging (n/a, trickle charge, slow charge, or fast
> > charging).  This allows things like battery diagnostics to
> > determine what the battery/EC is doing without resorting to
> > changing the 'status' sysfs output.
> 
> > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> 
> This looks good to me.  Could you please keep me on the CC for any
> future revisions of this patch, I can make use of this in the WM8350
> driver.

Sure.


> 
> > +	static char *charge_type[] = {
> > +		"N/A", "Trickle", "Slow", "Fast"
> > +	};
> 
> I'd be tempted to make "N/A" be "Unknown" to match the style of the
> rest of the attributes.  I'm also not sure that we need a slow type,
> but equally it shouldn't do any harm.


It's known though, right? :)   It could just as easily be "None",
"Unknown", etc, but I'm not particularly picky.  As far as the slow
type, I don't see the need either, but I assumed Anton was aware of
devices that differentiated between slow and trickle charging.
