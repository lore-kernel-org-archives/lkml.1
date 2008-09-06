Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYIFMna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYIFMna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYIFMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:43:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:34634 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYIFMnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:43:13 -0400
Date: Sat, 6 Sep 2008 21:43:09 +0900
To: bzolnier@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide/Kconfig: mark ide-scsi as deprecated
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200809051938.24933.bzolnier@gmail.com>
References: <200809031943.55605.bzolnier@gmail.com>
	<20080904033222O.fujita.tomonori@lab.ntt.co.jp>
	<200809051938.24933.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080906214318P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 19:38:24 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> Hi,
> 
> On Wednesday 03 September 2008, FUJITA Tomonori wrote:
> > On Wed, 3 Sep 2008 19:43:55 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > On Wednesday 03 September 2008, FUJITA Tomonori wrote:
> > > > On Tue, 19 Aug 2008 21:11:44 +0200
> > > > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > > > 
> > > > > Mark ide-scsi as deprecated and remove stale/bogus documentation.
> > > > > 
> > > > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > ---
> > > > >  drivers/ide/Kconfig |   16 +---------------
> > > > >  1 file changed, 1 insertion(+), 15 deletions(-)
> > > > 
> > > > Can we add ide-scsi to Documentation/feature-removal-schedule.txt?
> > > 
> > > Sure, care to send a patch?
> > 
> > 2.6.30 is too far?
> 
> It is IMHO.

let's try 2.6.29 to see if someone is against it.


> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] add deprecated ide-scsi to feature-removal-schedule.txt
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  Documentation/feature-removal-schedule.txt |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index eb1a47b..feb84b0 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -322,3 +322,11 @@ Why:  Accounting can now be enabled/disabled without kernel recompilation.
> >        controlled by a kernel/module/sysfs/sysctl parameter.
> >  Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
> >  
> > +---------------------------
> > +
> > +What: ide-scsi (BLK_DEV_IDESCSI)
> > +When: 2.6.30
> > +Why:  The 2.6 kernel supports direct writing to ide CD drives, which
> > +      eliminates the need for ide-scsi. The new method is more
> > +      efficient in every way.
> > +Who:  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Thanks but I thought that you would also want to handle the removal patch?

Ok, I'll take care of it if you like.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] add deprecated ide-scsi to feature-removal-schedule.txt

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index eb1a47b..83c88ca 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -322,3 +322,11 @@ Why:  Accounting can now be enabled/disabled without kernel recompilation.
       controlled by a kernel/module/sysfs/sysctl parameter.
 Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
 
+---------------------------
+
+What: ide-scsi (BLK_DEV_IDESCSI)
+When: 2.6.29
+Why:  The 2.6 kernel supports direct writing to ide CD drives, which
+      eliminates the need for ide-scsi. The new method is more
+      efficient in every way.
+Who:  FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
-- 
1.5.4.2



