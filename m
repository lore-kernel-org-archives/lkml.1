Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXA3V2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXA3V2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXA3V2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:28:14 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:49876 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbXA3V2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:28:13 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200701301701.41079.rjw@sisk.pl>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org>
	 <200701300357.34304.lenb@kernel.org>  <200701301701.41079.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 08:28:11 +1100
Message-Id: <1170192491.4308.20.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2007-01-30 at 17:01 +0100, Rafael J. Wysocki wrote:
> The freezer in 2.6.20-rc6 should be SMP-safe and the patches to change
> the suspend-resume code ordering are in -mm:
> 
> pm-change-code-ordering-in-mainc.patch
> swsusp-change-code-ordering-in-diskc.patch
> swsusp-change-code-order-in-diskc-fix.patch
> swsusp-change-code-ordering-in-userc.patch
> swsusp-change-code-ordering-in-userc-sanity.patch
> swsusp-change-pm_ops-handling-by-userland-interface.patch
> 
> I have no problems whatsoever with these patches on SMP boxes and if anyone
> has, please let me know.

I've been running an SMP box here with the matching changes for
Suspend2, with no problems. I believe the algorithm looks good.

Regards,

Nigel

