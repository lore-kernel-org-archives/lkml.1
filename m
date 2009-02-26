Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZBZUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZBZUyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZBZUyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:54:05 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:58799 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbZBZUyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:54:04 -0500
Subject: Re: [patch 2.6.29-rc6 1/2] regulator: enumerate voltages (v2)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <200902261148.36892.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	 <200902231245.44360.david-b@pacbell.net>
	 <200902231252.01980.david-b@pacbell.net>
	 <200902261148.36892.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 20:53:58 +0000
Message-Id: <1235681638.31223.57.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 11:48 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Add a basic mechanism for regulators to report the discrete
> voltages they support:  list_voltage() enumerates them using
> selectors numbered from 0 to an upper bound.
> 
> Use those methods to force machine-level constraints into bounds.
> (Example:  regulator supports 1.8V, 2.4V, 2.6V, 3.3V, and board
> constraints for that rail are 2.0V to 3.6V ... so the range of
> voltages is then 2.4V to 3.3V on this board.)
> 
> Export those voltages to the regulator consumer interface, so for
> example regulator hooked up to an MMC/SD/SDIO slot can report the
> actual voltage options available to cards connected there.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Applied with git-am merge conflicts. It builds ok, can you check against
your tree.

Thanks

Liam

