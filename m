Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbZHHHpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbZHHHpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 03:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933628AbZHHHpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 03:45:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45910 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459AbZHHHp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 03:45:29 -0400
Date: Sat, 8 Aug 2009 08:45:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20090808074523.GA5005@sirena.org.uk>
References: <1249658970-11100-1-git-send-email-anuj.aggarwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249658970-11100-1-git-send-email-anuj.aggarwal@ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/8] Regulator: Added board-dependent code for TPS65023
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 08:59:30PM +0530, Anuj Aggarwal wrote:

> +		},
> +		.num_consumer_supplies = 1,
> +		.consumer_supplies = &tps65023_core_consumers,
> +	},

This is all OK but as a style thing it's better to use ARRAY_SIZE() for
the number of consumers even if there's just one since that way if
someone adds another consumer they don't need to remember to adjust the
array length.
