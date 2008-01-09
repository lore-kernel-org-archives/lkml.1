Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYAIIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYAIIfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYAIIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:35:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58622 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYAIIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:35:34 -0500
Date: Wed, 9 Jan 2008 08:34:48 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't drain
Message-ID: <20080109083448.GA26781@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080108160610.53694773.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108160610.53694773.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 04:06:10PM -0800, Andrew Morton wrote:
> One hopes that doing a printk from within uart_suspend_port() will dtrt if
> that port is (was?) being used as a console.

Well, the preceding code shuts down the console side if the port is a
console - so this printk should never make it back to the UART in that
case.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
