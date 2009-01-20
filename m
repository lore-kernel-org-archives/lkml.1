Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbZATUZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbZATUZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZATUZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:25:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2480 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZATUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:25:21 -0500
Date: Tue, 20 Jan 2009 20:25:11 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@kernel.org>
Message-ID: <20090120202511.GA6864@sirena.org.uk>
References: <4975BE69.5040106@cam.ac.uk> <20090120124338.GA31521@sirena.org.uk> <4975CAF5.9090607@cam.ac.uk> <4975CF70.5080802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975CF70.5080802@gmail.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: regulator: Add disable_on_boot flag to constraints.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 01:19:44PM +0000, Jonathan Cameron wrote:

> index 3794773..fc0a641 100644
> --- a/include/linux/regulator/machine.h
> +++ b/include/linux/regulator/machine.h
> @@ -112,10 +112,10 @@ struct regulation_constraints {
>      suspend_state_t initial_state; /* suspend state to set at init */
>  
>      /* constriant flags */
> -    unsigned always_on:1;    /* regulator never off when system is on */
> -    unsigned boot_on:1;    /* bootloader/firmware enabled regulator */
> -    unsigned apply_uV:1;    /* apply uV constraint iff min == max */
> +    unsigned always_on:1;        /* regulator never off when system on */
> +    unsigned boot_on:1;        /* bootloader/firmware enabled reg */
> +    unsigned disable_on_boot:1;    /* regulator to be disabled at boot */
> +    unsigned apply_uV:1;        /* apply uV constraint iff min == max */
>  };

This needs kerneldoc adding for the new entry.  Other than that

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
