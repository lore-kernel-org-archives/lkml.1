Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbXBJUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbXBJUkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXBJUkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:40:00 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47434 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751851AbXBJUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:39:59 -0500
Date: Sat, 10 Feb 2007 21:40:04 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Lee Revell <rlrevell@joe-job.com>
Cc: nigel@nigel.suspend2.net, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070210204004.GO12958@stusta.de>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no> <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no> <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca> <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com> <1171073398.3863.9.camel@nigel.suspend2.net> <75b66ecd0702091822n19cf88b8k63bbd705cf5367ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0702091822n19cf88b8k63bbd705cf5367ae@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 09:22:48PM -0500, Lee Revell wrote:
> On 2/9/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> >On Fri, 2007-02-09 at 20:59 -0500, Lee Revell wrote:
> >> On 2/9/07, Robert Hancock <hancockr@shaw.ca> wrote:
> >> > I would disagree that it's a peripheral issue, it's pretty core these
> >> > days, at least for any hardware that you can stuff in a laptop (though 
> >a
> >> > fair number of desktops get suspended and resumed these days too).
> >>
> >> Servers are still the most important Linux market, and don't care
> >> about suspend/resume.  I would consider implementing suspend./resume
> >> for a driver that will only be used in server or HPC class hardware a
> >> waste of valuable development resources.
> >
> >Not necessarily. Imagine suspending to disk in order to replace a faulty
> >card. That could be way faster and less disruptive than shutting down
> >normally and loosing caches and so on.
> >
> 
> Hmm.  If uptime is critical I would make sure to have redundant
> systems anyway and I would just reboot the thing.  I would not expect
> the suspend/resume paths on server class hardware like 10gig ethernet,
> Infiniband adapters, or high end SCSI to be particularly well tested.
>...

10gig ethernet will be commodity hardware 5 years from now like 
1gig ethernet today where you can get cards for 12 Euro and switches for 
40 Euro.

> Lee

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

