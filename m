Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYICScx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYICScx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYICSco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:32:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:46232 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbYICScn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:32:43 -0400
Date: Thu, 4 Sep 2008 03:32:40 +0900
To: bzolnier@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide/Kconfig: mark ide-scsi as deprecated
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200809031943.55605.bzolnier@gmail.com>
References: <200808192111.45351.bzolnier@gmail.com>
	<20080903094402G.fujita.tomonori@lab.ntt.co.jp>
	<200809031943.55605.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904033222O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 19:43:55 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 03 September 2008, FUJITA Tomonori wrote:
> > On Tue, 19 Aug 2008 21:11:44 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > Mark ide-scsi as deprecated and remove stale/bogus documentation.
> > > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > ---
> > >  drivers/ide/Kconfig |   16 +---------------
> > >  1 file changed, 1 insertion(+), 15 deletions(-)
> > 
> > Can we add ide-scsi to Documentation/feature-removal-schedule.txt?
> 
> Sure, care to send a patch?

2.6.30 is too far?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] add deprecated ide-scsi to feature-removal-schedule.txt

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index eb1a47b..feb84b0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -322,3 +322,11 @@ Why:  Accounting can now be enabled/disabled without kernel recompilation.
       controlled by a kernel/module/sysfs/sysctl parameter.
 Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
 
+---------------------------
+
+What: ide-scsi (BLK_DEV_IDESCSI)
+When: 2.6.30
+Why:  The 2.6 kernel supports direct writing to ide CD drives, which
+      eliminates the need for ide-scsi. The new method is more
+      efficient in every way.
+Who:  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
-- 
1.5.4.2

