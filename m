Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZCXWTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZCXWTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZCXWTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:19:02 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55245 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCXWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:19:00 -0400
Date: Tue, 24 Mar 2009 22:18:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: alsa-devel@alsa-project.org, dbaryshkov@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [RESEND] [PATCH] pxa2xx-ac97: fix displaying GSR after reset
	timeout
Message-ID: <20090324221841.GC15455@n2100.arm.linux.org.uk>
References: <gq8unj$6og$1@ger.gmane.org> <1237911929-29895-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237911929-29895-1-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 05:25:28PM +0100, Luotao Fu wrote:
> the variable gsr_bit is set in isr. It is however set to 0 and interrupts are
> disabled prior to reset on pxa27x and pxa3xx. Hence it doesn't make a lot of
> sense to show the content of gsr_bit in case of a reset timeout.

It would make more sense to put "GSR | gsr_bits" into a temporary variable
for testing, and then printing so that the value printed is the exact
value which was tested, not somehting that may have changed.

Also, you've resent your patch but omitted the ALSA mailing list.
