Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbZD2RYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbZD2RYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZD2RYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:24:21 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:45089 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753189AbZD2RYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:24:21 -0400
Message-ID: <884894.99151.qm@web32602.mail.mud.yahoo.com>
X-YMail-OSG: zFxZ.f8VM1ldaOjnDDxhsdz3lIZNPB9mYUXXEiLfavEMoiQgv7FF_SB4yhyOLU43Hw4ezsghKM9z0BsgtSQHOuItGwGqtyTEu1pR8hB7VoHlJGKOD3pfYnC07GatGlsAmnbFLcW8e.AgHfbajnpq3mszj3O3AmWpgX8C_PooKDreHBFIosjBKjmOY940D6XYZB6N1QUTrCYD_INVnEoekAHfmrtT.YIFJEoFAclef2jiLbtxWRz_BTZ24J7CSbwc3pkUJGxxzYBZuVLyp1l.OHwdJ2IKeOq5S0IK9qhssvanSL_IkgEO.EbYxIyheJjhZoql.YJFHMJApAApi.zYEx0-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk>
Date: Wed, 29 Apr 2009 10:24:20 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090429120827.GI8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Al Viro <viro@ZenIV.linux.org.uk>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Galbraith <efault@gmx.de>; Martin Knoblauch <knobi@knobisoft.de>; Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; tigran aivazian <tigran@aivazian.fsnet.co.uk>
> Sent: Wednesday, April 29, 2009 2:08:28 PM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, Apr 29, 2009 at 01:17:55AM -0700, Andrew Morton wrote:
> 
> > > > > Questions remains: was this intentional? It breaks existing userspace 
> and should therefore be considered a regression - right? On the other hand, it 
> will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets 
> backported. Any ideas?
> > > > 
> > > > afaik that was unintentional and was probably a mistake.
> > > > 
> > > > I wonder how we did that.
> > > 
> > > 
> > > > [hotplug]# grep sysfs /proc/mounts
> > > > none /sys sysfs rw,relatime 0 0
> > > > /sys /sys sysfs rw,relatime 0 0
> > > 
> > > ___(I wonder how the heck that is accomplished)
> > 
> > Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> > show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> > cc's viro).
> 
> Er...  Somebody mounting sysfs twice?  From some init script and from
> /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> have been done to cause that...

 One definitely comes from /etc/fstab, but I am not aware of any other script mounting sysfs in my userspace.

Cheers
Martin

