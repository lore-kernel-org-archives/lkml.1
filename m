Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXB0ME6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXB0ME6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXB0ME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:04:58 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3381 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXB0ME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:04:57 -0500
Date: Tue, 27 Feb 2007 12:04:50 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: __must_check and driver model
Message-ID: <20070227120450.GB2154@flint.arm.linux.org.uk>
Mail-Followup-To: Linux Kernel List <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still seeing lots of warnings about unchecked return codes from
driver model functions.

These must have been around for at least three months, if not longer,
and there seems to be very little progress towards resolving them.
Maybe if no one cares about fixing the warnings, we shouldn't have
the warnings at all since they're just mere noise.

Can we resolve to either fix the warnings, or remove the ineffective
__must_check annotations?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
