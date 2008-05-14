Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbYENOyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbYENOyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbYENOye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:54:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52841 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762644AbYENOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:54:33 -0400
Date: Wed, 14 May 2008 16:54:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       jirislaby@gmail.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Message-ID: <20080514145416.GD6260@ucw.cz>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com> <20080501142305.77433e50.akpm@linux-foundation.org> <481A3781.8080100@gmail.com> <1209679559.14864.33.camel@localhost.localdomain> <20080501153048.2a8d356f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501153048.2a8d356f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >> megaraid_sas suspend and resume are inappropriatelly placed in
> > > >> __devinit section.
> > > > 
> > > > That's a box-killer, isn't it?
> > > 
> > > I think so -- the non-CONFIG_HOTPLUG ones.
> > 
> > CONFIG_HOTPLUG is only settable to 'n' if you're CONFIG_EMBEDDED which
> > has a zero set intersection with the users of megaraid, so in practical
> > terms, there's no actual box it could kill.
> 
> who suspends and resumes servers?

It actually has some silly name like 'green IT'.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
