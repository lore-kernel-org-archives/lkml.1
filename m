Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYJDURQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYJDURQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYJDURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:17:00 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35284 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYJDUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:16:59 -0400
Subject: Re: [Bug #11442] btusb hibernation/suspend breakage in current -git
From: Marcel Holtmann <marcel@holtmann.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <yWwteD.A.ab.L675IB@wind>
References: <0pOgGB.A.uLG.E475IB@wind>  <yWwteD.A.ab.L675IB@wind>
Content-Type: text/plain
Date: Sat, 04 Oct 2008 22:17:11 +0200
Message-Id: <1223151431.11272.54.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11442
> Subject		: btusb hibernation/suspend breakage in current -git
> Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> Date		: 2008-08-25 11:37 (41 days old)
> References	: http://marc.info/?l=linux-bluetooth&m=121966402012074&w=4
> Handled-By	: Oliver Neukum <oliver@neukum.org>
> Patch		: http://marc.info/?l=linux-bluetooth&m=121967226027323&w=4
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=11442#c1

the patch is not the actual fix for it. It is just a band aid. As you
confirmed, the double free patch fixes it. See my pull request, but it
didn't make it into Linus' tree yet.

Regards

Marcel


Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git master

This will update the following files:

 drivers/bluetooth/bpa10x.c |    2 --
 drivers/bluetooth/btusb.c  |    7 ++++---
 2 files changed, 4 insertions(+), 5 deletions(-)

through these ChangeSets:

Marcel Holtmann (2):
    [Bluetooth] Fix double frees on error paths of btusb and bpa10x drivers
    [Bluetooth] Add reset quirk for new Targus and Belkin dongles


