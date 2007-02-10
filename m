Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbXBJEfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbXBJEfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 23:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXBJEfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 23:35:34 -0500
Received: from ms-smtp-06.ohiordc.rr.com ([65.24.5.140]:52710 "EHLO
	ms-smtp-06.ohiordc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXBJEfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 23:35:33 -0500
Date: Fri, 9 Feb 2007 23:35:15 -0500
To: Lee Revell <rlrevell@joe-job.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070210043514.GA29679@nineveh.rivenstone.net>
Mail-Followup-To: Lee Revell <rlrevell@joe-job.com>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>, nigel@nigel.suspend2.net
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no> <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no> <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca> <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
From: jhf@columbus.rr.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 08:59:55PM -0500, Lee Revell wrote:
> On 2/9/07, Robert Hancock <hancockr@shaw.ca> wrote:
> >I would disagree that it's a peripheral issue, it's pretty core these
> >days, at least for any hardware that you can stuff in a laptop (though a
> >fair number of desktops get suspended and resumed these days too).
>
> Servers are still the most important Linux market, and don't care
> about suspend/resume.  I would consider implementing suspend./resume
> for a driver that will only be used in server or HPC class hardware a
> waste of valuable development resources.

    Please allow me to be offensively blunt for a moment.

    So, the situation seems to be:

    1. The work of the suspend developer who engages the users who put
       effort into making suspend work on their hardware (bless
       their addled little heads) often doesn't meet kernel standards,
       or isn't well enough documented to prove the real *need* for
       the features and/or hacks that have happened to get actual
       users' systems sleeping and running again.

    2. The swsusp maintainer continues in the belief that as long as
       their are no bug reports in kernel bugzilla or crossing the
       (relatively obscure) swsusp mailing lists, it has zarro boogs
       and meanwhile works on the fourth implementation of suspend
       support in as many years.  It's in CVS on sourceforge.  There's
       no documentation whatsoever.

    3. There's another guy who appears to be doing a lot of work, so I
       shan't leave him out.  Like the two developers previously
       mentioned, he seems to be working pretty hard on the whole
       thing.  The previously mentioned fourth suspend implementation
       seems to be largely his doing, for good and for ill.

    4. "Everybody" knows suspend doesn't work on Linux without a huge
       amount of tinkering, deep magic, and dead chickens.  Only
       Gentoo users seem to bother; everyone else waits for Ubuntu
       12.04 wherein suspend will "just work".  The Gentoo users all
       use swsusp2, as it contains the hacks to work around:

    5. All the suspend developers blame the lack of power-management
       support in drivers for the inablility of Linux to properly
       suspend on anything that doesn't support APM.

    6. Getting proper power-management support in Linux device drivers
       is not a priority; drivers without any power management support
       whatsoever should not only be accepted -- they should be merged
       without comment or complaint.

   How is working suspend support ever supposed to happen?

--
Joseph Fannin
jfannin@gmail.com || jhf@columbus.rr.com

