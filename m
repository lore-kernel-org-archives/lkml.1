Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZE3J4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZE3J4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZE3Jzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:55:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57846 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZE3Jzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:55:55 -0400
Date: Sat, 30 May 2009 11:55:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Cyril Hrubis <metan@ucw.cz>
Subject: Re: unbreak suspend on zaurus on 2.6.30-rc6
Message-ID: <20090530095550.GA19058@elf.ucw.cz>
References: <20090529105619.GA24187@elf.ucw.cz> <1243632629.9207.5.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243632629.9207.5.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-29 23:30:29, Stanislav Brabec wrote:
> Pavel Machek wrote:
> 
> > This is hacky patch to unbreak suspend on -rc6; perhaps it will be
> > useful to someone.
> 
> Thanks for the patch. I tried rc7 yesterday with same problem.
> 
> Your patch makes resume working again. Serial console does not work
> after resume, inserting or removing charger causes resume, and syslog is
> a bit noisy now.

Plus I guess I should mention that my patch disables offline
charging. So be sure to shutdown for charger...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
