Return-Path: <linux-kernel-owner+w=401wt.eu-S965174AbXCAPKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174AbXCAPKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965171AbXCAPKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:10:41 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2974 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175AbXCAPKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:10:40 -0500
Date: Thu, 1 Mar 2007 15:10:22 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070301151022.GA15447@flint.arm.linux.org.uk>
Mail-Followup-To: Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk> <45DDB096.2020807@inov.pt> <20070222170354.GB633@flint.arm.linux.org.uk> <45E6D628.90800@inov.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E6D628.90800@inov.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 01:33:28PM +0000, Jose Goncalves wrote:
> I've also done your suggestion and I've inserted "msleep(10);" just
> before the "And clear the interrupt registers again for luck." and my
> application is now running without problems fore more than 24H! So,
> inserting a delay in this point definitely makes some difference (has
> was with adding some extra printk() in several points of
> serial8250_startup()).
> 
> This said, for me, this is definitely a software problem. The question
> is were?

I'm personally convinced it's hardware because according to my analysis
your CPU behaving in a way that the code is not asking it to do so.

Maybe others have some further insight; I certainly don't.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
