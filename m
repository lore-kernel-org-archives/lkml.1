Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYKPM7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYKPM7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYKPM7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:59:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYKPM7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:59:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Suspend regression in 2.6.25.18
Date: Sun, 16 Nov 2008 14:04:22 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161404.23072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Your commit

commit ffa4da2a25bb4ac08f710ac99827baf48a8f8d57
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Sep 3 21:37:08 2008 +0000

    clockevents: prevent multiple init/shutdown

    commit 9c17bcda991000351cb2373f78be7e4b1c44caa3 upstream

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

is reported to cause a resume regression on Lenovo x60, x41 and x61 (probably
other Lenovo boxes are affected as well) with 2.6.25.18.  At the same time, the
2.6.27.y kernels are reported to work correctly for the affected users.

Can you please try to identify the updstream commits that fix the problem on
these boxes?

Thanks,
Rafael
