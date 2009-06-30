Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZF3Lbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZF3Lbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZF3Lbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:31:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57878 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZF3Lbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:31:35 -0400
Date: Tue, 30 Jun 2009 12:31:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
	and use it for olpc driver
Message-ID: <20090630113135.GD13961@sirena.org.uk>
References: <20090630021730.44f86185@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630021730.44f86185@mycelium.queued.net>
X-Cookie: Only fools are quoted.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:17:30AM -0400, Andres Salomon wrote:

> This adds a new sysfs file called 'charge_type' which displays the type of
> charging (n/a, trickle charge, slow charge, or fast charging).  This allows
> things like battery diagnostics to determine what the battery/EC is doing
> without resorting to changing the 'status' sysfs output.

> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>

This looks good to me.  Could you please keep me on the CC for any
future revisions of this patch, I can make use of this in the WM8350
driver.

> +	static char *charge_type[] = {
> +		"N/A", "Trickle", "Slow", "Fast"
> +	};

I'd be tempted to make "N/A" be "Unknown" to match the style of the rest
of the attributes.  I'm also not sure that we need a slow type, but
equally it shouldn't do any harm.
