Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYABRrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYABRrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYABRrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:47:00 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:55594 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYABRrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:47:00 -0500
Date: Wed, 2 Jan 2008 11:45:58 -0600
From: Scott Wood <scottwood@freescale.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH/RFC] Add support for freescale watchdog to CPM serial
	driver.
Message-ID: <20080102174558.GA4398@loki.buserror.net>
References: <477513CC.3060109@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477513CC.3060109@scram.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 04:18:36PM +0100, Jochen Friedrich wrote:
> If a freescale watchdog device node is present, reset the watchdog
> while waiting for serial input.

Hmm...  I don't like combining the watchdog and serial code together.  What
if some other serial device is used with this watchdog?  The serial driver
should only have to call an externally provided poke_watchdog() function.

-Scott
