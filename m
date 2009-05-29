Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbZE2PCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbZE2PCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZE2PCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:02:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbZE2PCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:02:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/4] [MTD] compat_ioctl cleanup
Date: Fri, 29 May 2009 16:02:36 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: Kevin Cernekee <kpc.mtd@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
References: <a95a62fe0904082253i119f8660y6a73835a163394f5@mail.gmail.com> <1243609086.19886.179.camel@macbook.infradead.org>
In-Reply-To: <1243609086.19886.179.camel@macbook.infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200905291602.37190.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19kQca/f+yp1xlv5SkHO6MFwb61dptGGqBGDkZ
 IOQabrf60jYSXR/kskOdFgr7RrRTx4ceAqoWJQM6Ch5/KtMlm1
 /TJIkxXRcN0SsdByN5RvqEc2DY+NzTT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 May 2009, David Woodhouse wrote:
> On Wed, 2009-04-08 at 22:53 -0700, Kevin Cernekee wrote:
> > 
> > +static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
> > +       unsigned long arg)
> > +{
> > +       struct mtd_file_info *mfi = file->private_data;
> > +       struct mtd_info *mtd = mfi->mtd;
> > +       void __user *argp = (void __user *)arg;
> 
> Shouldn't that be 'argp = compat_ptr(arg)' ?

Yes, that's right. I missed this when I looked at the patches.

	Arnd <><
