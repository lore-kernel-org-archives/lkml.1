Return-Path: <linux-kernel-owner+w=401wt.eu-S965850AbXBOKtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850AbXBOKtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965851AbXBOKtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:49:21 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3224 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965850AbXBOKtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:49:20 -0500
Date: Thu, 15 Feb 2007 10:49:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: akennedy@techmoninc.com
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Serial console issues.
Message-ID: <20070215104907.GB15772@flint.arm.linux.org.uk>
Mail-Followup-To: akennedy@techmoninc.com, Alan <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <20070214173922.bfc52cea95091b0fffcb409eab6296ba.d67be632a9.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214173922.bfc52cea95091b0fffcb409eab6296ba.d67be632a9.wbe@email.secureserver.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 05:39:22PM -0700, akennedy@techmoninc.com wrote:
> Well, this is the most bastardized sucker I've ever seen. . . I have had
> no end of trouble with it (couldn't even get a boot loader to work with
> it - had to write my own).  And, as luck would have it, the serial port
> is no different.  Using setserial, I changed the type of this port to a
> 16550A and all my problems went away.  The question now remains:  How
> can I FORCE the Linux serial driver to see this as a 16550A -- As I
> before stated, I know that this has a 16-byte buffer.  Therefore, the
> 16750 with its mammoth buffer size is killing this serial port.  Short
> of modifying the kernel (which I'd rather not do) or including the
> setserial with the kernel image (also I'd rather not do as I only have
> 2.3 MB of storage on this device) I need a command line parameter to
> control the serial line -- is there one?  A build option?  PLEASE
> SOMETHING???

No.  Use setserial which is a small tool to achieve what you require.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
