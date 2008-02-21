Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYBUImm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYBUImm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYBUIme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:42:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52402 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYBUImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:42:33 -0500
Date: Thu, 21 Feb 2008 08:41:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [UPDATED v2][PATCH 0/6] regulator: voltage and current regulator framework
Message-ID: <20080221084128.GA4931@flint.arm.linux.org.uk>
References: <1203527326.4071.88.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203527326.4071.88.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 05:08:46PM +0000, Liam Girdwood wrote:
> This patch series provides a generic framework to allow device drivers
> to control voltage and current regulators on SoC based devices (e.g.
> phones, gps, media players).

Note that I'm explicitly avoiding commenting on this as far as PXA3xx
devices go, until we're further down the road with PM support on that
SoC.  It's not clear at present whether a generic PMIC framework will
be suitable for this SoC since it's my understanding from Marvell that
we need to talk to the PMIC from IRQs-off contexts.

So don't take my silence as some sort of acceptance of this code; it
isn't.
