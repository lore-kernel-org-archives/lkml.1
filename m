Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZF0L1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZF0L1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZF0L1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:27:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40800 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbZF0L1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:27:17 -0400
Date: Wed, 24 Jun 2009 17:02:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: unbreak suspend on zaurus on 2.6.30-rc6
Message-ID: <20090624150252.GC1784@ucw.cz>
References: <20090529105619.GA24187@elf.ucw.cz> <1243632629.9207.5.camel@utx.utx.cz> <20090530095550.GA19058@elf.ucw.cz> <gvrghs$6oa$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gvrghs$6oa$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-05-30 14:41:00, Dmitry Eremin-Solenikov wrote:
> Pavel Machek wrote:
> 
> > On Fri 2009-05-29 23:30:29, Stanislav Brabec wrote:
> >> Pavel Machek wrote:
> >> 
> >> > This is hacky patch to unbreak suspend on -rc6; perhaps it will be
> >> > useful to someone.
> >> 
> >> Thanks for the patch. I tried rc7 yesterday with same problem.
> >> 
> >> Your patch makes resume working again. Serial console does not work
> >> after resume, inserting or removing charger causes resume, and syslog
> >> is a bit noisy now.
> > 
> > Plus I guess I should mention that my patch disables offline charging.
> > So be sure to shutdown for charger...
> 
> Or charge online? IIRC Zaurii don't have any problems with online charging,
> do they?

Not sure. I'd have to build some  measuring equipment for that.

They seem to charge slower when 'on', but I'm not sure how much slower...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
