Return-Path: <linux-kernel-owner+w=401wt.eu-S1751044AbXCDTqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbXCDTqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 14:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXCDTqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 14:46:46 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2333 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXCDTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 14:46:45 -0500
Date: Sun, 4 Mar 2007 19:46:32 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Message-ID: <20070304194632.GC30345@flint.arm.linux.org.uk>
Mail-Followup-To: Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org,
	Robin Getz <rgetz@blackfin.uclinux.org>
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 07:03:02PM -0500, Mike Frysinger wrote:
> the console= bootcmd allows for controlling of the initial state of
> flow control by adding/omitting the 'r' suffix ...

The console command *only* sets the state for the kernel's use of one
serial port.  It does not affect any other serial port, so tying
random RTS behaviours into that command line option is absolutely
silly.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
