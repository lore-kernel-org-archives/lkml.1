Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYELLy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYELLy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYELLyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:54:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2981 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYELLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:54:18 -0400
Date: Mon, 12 May 2008 12:54:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: liam.girdwood@wolfsonmicro.com, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
Message-ID: <20080512115416.GB23216@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	liam.girdwood@wolfsonmicro.com, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org
References: <1210589112-12208-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210589112-12208-1-git-send-email-cooloney@kernel.org>
X-Cookie: Beam me up, Scotty!  It ate my phaser!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 06:45:12PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Thanks, I've applied this to the ASoC git tree.  CCing in
alsa-devel@alsa-project.org - ALSA patches should go via there.

> +static int ad1980_soc_suspend(struct platform_device *pdev,
> +	pm_message_t state)
> +{
> +	return 0;
> +}
> +
> +static int ad1980_soc_resume(struct platform_device *pdev)
> +{
> +	return 0;
> +}

Are you sure about these?  I would expect the suspend and resume
functions to either do some register writes or be omitted if they don't
do anything.  Standard AC97 codecs would have some power management via
register 0x26 if they were doing anything.
