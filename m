Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYGBXOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYGBXOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYGBXO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:14:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYGBXO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:14:28 -0400
Date: Thu, 3 Jul 2008 00:14:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PalmTX initial support
Message-ID: <20080702231415.GI19143@flint.arm.linux.org.uk>
References: <200807022232.47294.marek.vasut@gmail.com> <20080702204110.GA22107@fluff.org.uk> <20080702220356.GE19143@flint.arm.linux.org.uk> <200807030053.00019.marek.vasut@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807030053.00019.marek.vasut@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 12:52:59AM +0200, Marek Vasut wrote:
> ok, I fixed what I was able to grasp. That is :
> 
> -Are these useful? + Dittos
> -Don't you have to configure GPIO47 as a GPIO to change its state?
> Since you don't, and I assume you've tested this, I think you've
> proven that you can delete the fiddling with GPIO47.
> 
> Actually GPIO47 was set up before by palmos (since Im not booting from clean 
> state, but from palmOS) so it wasnt necessary to set it up again in linux and 
> it didnt cause any problems. Booting it from clean state would cause 
> problems, so I fixed it.

Bear in mind then that it may work for the first time you enable IrDA,
but if you subseqently disable and re-enable it, GPIO47 will be assigned
to the UART instead.

> That's it, but what I still dont understand is the pxa branch (and new PWM 
> stuff). Im currently using mainline (linus's tree), so that's not the tree I 
> should use ?

from memory:

http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-rmk pxa

where 'http:...' is the URL and 'pxa' is the branch name.  It's currently
quite a bit older than mainline at the moment.
