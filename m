Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbXBEQvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbXBEQvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXBEQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:51:04 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3204 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbXBEQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:51:01 -0500
Date: Mon, 5 Feb 2007 16:50:45 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205165045.GD4563@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <Pine.LNX.4.64.0702050829360.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702050829360.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 08:32:50AM -0800, Linus Torvalds wrote:
> If "X" then needs Y, Z and something else to actually compile, then that 
> Kconfig file should DAMN WELL use "select". Stop claiming anything else!

Disagree.  The UI app should handle this and ask the user if it's okay
to proceed to enable that option along with the others.

All we should be doing in the Kconfig files is describing the
dependencies for user-visible symbols.  If we want to allow the
user to enable something, it's up to the UI _itself_ to sort out the
dependencies.

Principle of least surprise.  Principle of giving the user control.

As I say at the moment throwing "select" is just moving the bloody
problem around.  It's not actually _solving_ anything, and anyone
who thinks otherwise is a nutcase!

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
