Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYABXmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYABXmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYABXlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:41:52 -0500
Received: from kolab.mylinuxtime.de ([212.112.242.22]:49087 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYABXlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:41:51 -0500
X-Spam-ASN: AS24900 212.112.224.0/19
From: Christian Hesse <mail@earthworm.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend2-devel] Reboot problem
Date: Thu, 3 Jan 2008 00:41:34 +0100
User-Agent: KMail/1.9.7
Cc: nigel@nigel.suspend2.net, suspend2-devel@lists.tuxonice.net,
       "The place to get help!" <suspend2-users@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <477AC060.5040004@nigel.suspend2.net> <200801020124.13935.mail@earthworm.de> <200801021409.04682.rjw@sisk.pl>
In-Reply-To: <200801021409.04682.rjw@sisk.pl>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801030041.38495.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Rafael J. Wysocki wrote:
> On Wednesday, 2 of January 2008, Christian Hesse wrote:
> > On Wednesday 02 January 2008, Nigel Cunningham wrote:
> > > Hi Christian.
> > >
> > > Christian Hesse wrote:
> > > > On Tuesday 01 January 2008, Nigel Cunningham wrote:
> > > >> Third, regarding the patch itself, I'm taking my time in working
> > > >> towards the 3.0 release. We don't have any major bugs with 3.0-rc3
> > > >> reported [...].
> > > >
> > > > Well, I think I still have a bug, though it is possibly a mainline
> > > > problem and it's not a showstopper. After a suspend/resume cycle the
> > > > reboot does not work. The system hangs with "Rebooting system" (or
> > > > similar). After that you have to hard reset the system, which is not
> > > > really a problem as filesystems have been unmounted before. Reboot
> > > > without a suspend cycle before and halt with and without suspend
> > > > cycle work without problems.
> > >
> > > Just to clarify, do you mean rebooting after writing an image, or
> > > shutting down and rebooting? It could be that there's some change to
> > > the semantics in 2.6.24 that I haven't noticed yet.
> >
> > I speak about shutting down and rebooting. I have not used reboot after
> > writing an image for a long time now. Will test what happens in this
> > case.

Reboot after writing image does not work, too. The system hangs with "Ready to 
reboot".

> > I had the issue before 2.6.24(-rc) already, thought I don't know whether
> > there were times it worked. I use it way too seldom.
>
> Well, this is similar to http://bugzilla.kernel.org/show_bug.cgi?id=6655 ,
> which definitely is a mainline problem (still pending).

Yes, that sound like my problem. I will test the patches and keep the bug 
report in focus.
-- 
Regards,
Chris
