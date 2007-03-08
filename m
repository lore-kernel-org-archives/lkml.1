Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXCHPQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXCHPQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCHPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:16:24 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3700 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXCHPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:16:24 -0500
Date: Thu, 8 Mar 2007 15:16:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rob Prowel <prowel@kuchera.com>
Cc: Stuart MacDonald <stuartm@connecttech.com>, linux-kernel@vger.kernel.org
Subject: Re: questions about 8250 uart support for adhoc boards
Message-ID: <20070308151612.GD30023@flint.arm.linux.org.uk>
Mail-Followup-To: Rob Prowel <prowel@kuchera.com>,
	Stuart MacDonald <stuartm@connecttech.com>,
	linux-kernel@vger.kernel.org
References: <028501c75aa2$54ae9d80$294b82ce@stuartm> <45E49759.6050301@kuchera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E49759.6050301@kuchera.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 03:40:57PM -0500, Rob Prowel wrote:
> Stuart MacDonald wrote:
> >Would it be more intuitive to give ports the default uartclk of
> >1843200 at init time? That would avoid this issue, but would make the
> >baud rates come out wrong on hardware with a non-standard clock, if a
> >base baud wasn't specified.
> >
> >  
> 
> I prefer the option to specify the base baud rate in setserial from a 
> startup script.  Having the additional ports at BAUD 0 (unusable) until 
> some explicit action is taken strikes me as a safer option, provided 
> this gets properly documented in the kernel Documentation directory and 
> in Linux HOWTO docs.

Is someone going to do that?  Who volunteers?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
