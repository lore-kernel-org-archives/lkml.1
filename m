Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYLLS4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYLLS4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYLLS4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:56:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49171 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYLLS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:56:21 -0500
Date: Fri, 12 Dec 2008 19:58:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: smartmontools-support@lists.sourceforge.net,
       smartmontools-database-owner@lists.sourceforge.net,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Intel X25-E running Linux using XFS
Message-ID: <20081212185803.GE11974@elf.ucw.cz>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> Due to the 100k write cycle lifetime, I will not be performing any more 
> benchmarks on the SSD itself, such benchmarks are available on  
> techreport.com but just wanted to send out the smart data for the  
> smartmontools list and point out it is working with linux+ich7+xfs.
>
> Overall, whenever I do anything now its just like the entire machine is
> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>
> The techreport benchmarks are here:
> http://techreport.com/articles.x/15931

Actually I'd like to know... how does it behave during powerfails
while it is being written to?

Flashes I seen (USB / SD) developed bad sectors in that case, and
ext2/ext3 can't handle that. (And I don't think xfs can handle that
either).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
