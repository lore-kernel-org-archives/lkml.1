Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbZCYKe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbZCYKe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZCYKeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:34:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59805 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbZCYKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:34:18 -0400
Date: Wed, 25 Mar 2009 10:34:07 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Luotao Fu <l.fu@pengutronix.de>, dbaryshkov@gmail.com,
       alsa-devel@alsa-project.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [RESEND] [PATCH] pxa2xx-ac97: fix displaying GSR
	after reset timeout
Message-ID: <20090325103406.GA20936@sirena.org.uk>
References: <gq8unj$6og$1@ger.gmane.org> <1237911929-29895-1-git-send-email-l.fu@pengutronix.de> <20090324221841.GC15455@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324221841.GC15455@n2100.arm.linux.org.uk>
X-Cookie: Support your right to arm bears!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:18:41PM +0000, Russell King - ARM Linux wrote:

> It would make more sense to put "GSR | gsr_bits" into a temporary variable
> for testing, and then printing so that the value printed is the exact
> value which was tested, not somehting that may have changed.

Indeed - Luotao, please make this change.

> Also, you've resent your patch but omitted the ALSA mailing list.

Looks like it's there on the copies that reached here.
