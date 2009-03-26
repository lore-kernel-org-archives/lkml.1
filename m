Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbZCZO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbZCZO2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbZCZO2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:28:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52881 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbZCZO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:28:04 -0400
Date: Thu, 26 Mar 2009 14:27:51 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: linux@arm.linux.org.uk, dbaryshkov@gmail.com, alsa-devel@alsa-project.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pxa2xx-ac97: fix displaying GSR after reset timeout
Message-ID: <20090326142751.GF3771@sirena.org.uk>
References: <20090325103406.GA20936@sirena.org.uk> <1238069883-12445-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238069883-12445-1-git-send-email-l.fu@pengutronix.de>
X-Cookie: Baby On Board.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 01:18:03PM +0100, Luotao Fu wrote:
> the variable gsr_bit is set in isr. It is however set to 0 and interrupts are
> disabled prior to reset. Hence it doesn't make a lot of sense to show the
> content of gsr_bit in case of a reset timeout.

> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

Applied, thanks!
