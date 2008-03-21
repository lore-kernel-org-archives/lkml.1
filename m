Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYCUK5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYCUK5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYCUK5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:57:16 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57941 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbYCUK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:57:14 -0400
Date: Fri, 21 Mar 2008 11:56:49 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20080321105649.GA8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <3ae72650803202036i7aee418et23b1ec5ac72560f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650803202036i7aee418et23b1ec5ac72560f7@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 04:36:44AM +0100, Kay Sievers wrote:
> On Thu, Mar 6, 2008 at 1:09 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> > This patch adds the kernel side of the PPS support currently named
> >  "LinuxPPS".
> 
> >  diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
> >  new file mode 100644
> >  index 0000000..c25c91c
> >  --- /dev/null
> >  +++ b/drivers/pps/sysfs.c
> >  @@ -0,0 +1,130 @@
> 
> >  +void pps_sysfs_remove_source_entry(struct pps_device *pps)
> >  +{
> >  +       /* Delete info files */
> >  +       sysfs_remove_group(&pps->dev->kobj, &pps_group);
> >  +}
> >  +
> >  +int pps_sysfs_create_source_entry(struct pps_device *pps)
> >  +{
> >  +       int ret;
> >  +
> >  +       /* Create info files */
> >  +       ret = sysfs_create_group(&pps->dev->kobj, &pps_group);
> 
> Any specific reason you are creating the group by hand, and not assign
> it to the default group in your class? It would will let the core
> handle it for you. The device add uevent to userspace will happen
> before you added the attributes, which is usually not nice.

No any specific reason... I just supposed it was the-right-think(TM)!
:)

Can you please suggest me an URL where I can see how to rework the
code?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
