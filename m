Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZHAFRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZHAFRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 01:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZHAFRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 01:17:24 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:44834 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZHAFRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 01:17:23 -0400
Date: Sat, 1 Aug 2009 07:17:16 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Pierre Ossman <pierre@ossman.eu>
Cc: SDHCI development <sdhci-devel@lists.ossman.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: QUIRK_FORCE_HISPD (was: Re: Ricoh R5C822 and QUIRK_FORCE_DMA)
Message-ID: <20090801051716.GA28791@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Pierre Ossman <pierre@ossman.eu>,
	SDHCI development <sdhci-devel@lists.ossman.eu>,
	linux-kernel@vger.kernel.org
References: <20090430224524.GA9487@yamamaya.is-a-geek.org> <20090513195956.30f78012@mjolnir.ossman.eu> <20090609224145.GA11001@yamamaya.is-a-geek.org> <20090613125322.750a1180@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090613125322.750a1180@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> > On a related note, I had a little time to play a bit more with my
> > R5C822 and found that I can also force-enable HISPD mode, which
> > boost performance further.
> > 
> 
> This seems odd. What frequency is the controller reporting?
> 
> It could be that they originally wanted the controller to be
> high-speed, but that they had stability problems and turned it off.
> There is at least one other controller that went through that scenario.

I assume thats host->max_clk?
The controller seems to report 33MHz for that value.

[130484.232213] mmc0: Controller vendor_ver=02 sdhci_ver=00.
[130484.232213] mmc0: Controller caps=018021a1.
[130484.232213] SDHCI_INT_ENABLE: Can toggle bits e1ff01ff
[130484.232213] SDHCI_HOST_CONTROL: Can toggle bits 06
[130484.232213] DMA forced on (host quirk)
[130484.232213] sdhci-pci 0000:04:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[130484.232213] host->max_clk: 33000000
[130484.232213] HISPD forced on (host quirk)
[130484.232213] Verified that HOST_CONTROL bit SDHCI_CTRL_HISPD can be toggled
[130484.232213] Could not set SDHCI_CTRL_LED to 1!


-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
