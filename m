Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZILMma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZILMma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 08:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZILMm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 08:42:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36693 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZILMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 08:42:28 -0400
Date: Sat, 12 Sep 2009 13:42:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <20090912124229.GB4633@sirena.org.uk>
References: <Pine.LNX.4.64.0909121424420.8557@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909121424420.8557@pc-004.diku.dk>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.26.81
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/8, retry] sound/soc: introduce missing kfree
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 02:25:35PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kzalloc should free the allocated data.
> Error handling code following an ioremap should iounmap the allocated data.

Applied after manually fixing paths (the patch had a bunch of prefixes
in the directory name).  Thanks!
