Return-Path: <linux-kernel-owner+w=401wt.eu-S1030386AbXBZSGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030386AbXBZSGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030387AbXBZSGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:06:13 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030386AbXBZSGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:06:12 -0500
Date: Mon, 26 Feb 2007 18:05:54 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rob Prowel <prowel@kuchera.com>
Cc: Stuart MacDonald <stuartm@connecttech.com>, linux-kernel@vger.kernel.org
Subject: Re: questions about 8250 uart support for adhoc boards
Message-ID: <20070226180554.GA16857@flint.arm.linux.org.uk>
Mail-Followup-To: Rob Prowel <prowel@kuchera.com>,
	Stuart MacDonald <stuartm@connecttech.com>,
	linux-kernel@vger.kernel.org
References: <000001c75853$3e9599f0$294b82ce@stuartm> <45E312C1.5050802@kuchera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E312C1.5050802@kuchera.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 12:02:57PM -0500, Rob Prowel wrote:
> See below for a (script) dump of that demonstrates the behavior I 
> describe.  Additional ports are not configurable until a driver such as 
> fourport is loaded.  This is in 2.6.20.1 and 2.6.17 (those versions I 
> have tested).

Check what /proc/tty/driver/serial contains, rather than relying on
setserial.  setserial distributed by distros hasn't kept up with the
changes in the serial layer.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
