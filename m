Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZK0LNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZK0LNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZK0LNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:13:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47532 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZK0LNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:13:13 -0500
Date: Fri, 27 Nov 2009 11:12:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chaithrika U S <chaithrika@ti.com>
Cc: "'A. Porodko'" <panda@chelcom.ru>, "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>,
       "'Troy Kisky'" <troy.kisky@boundarydevices.com>,
       "'David Brownell'" <dbrownell@users.sourceforge.net>,
       "'Kevin Hilman'" <khilman@deeprootsystems.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] Sound support for Neuros OSD2 Davinci based board.
Message-ID: <20091127111254.GB29512@sirena.org.uk>
References: <4B0E7D5E.3080906@chelcom.ru> <002e01ca6e9c$2dab6040$890220c0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01ca6e9c$2dab6040$890220c0$@com>
X-Cookie: Sorry.  Nice try.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 06:57:19PM +0530, Chaithrika U S wrote:

> @@ -246,6 +249,9 @@ static int __init evm_init(void)
>  	if (machine_is_davinci_evm()) {
>  		evm_snd_dev_data = &evm_snd_devdata;
>  		index = 0;
> +	} else if (machine_is_neuros_osd2()) {
> +		evm_snd_dev_data = &evm_snd_devdata;
> +		index = 0;

> The above can be combined with the check for DaVinci EVM
> 	if (machine_is_davinci_evm() ||
> 				(machine_is_neuros_osd2()) {
>  		evm_snd_dev_data = &evm_snd_devdata;
>  		index = 0;

I raised the same query when Andrey sent an off-list copy to me by
mistake - he said that in future he intends to extend the driver to 
have additional features not present on the EVM (though for me that
could always change the || later).

Andrey, with Linux kernel patches reply to all is generally the way
forward.
