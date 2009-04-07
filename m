Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZDGHPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZDGHPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZDGHO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:14:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47603 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZDGHOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:14:55 -0400
Subject: Re: [Bug #12499] Problem with using bluetooth adaper connected to
 usb port
From: Marcel Holtmann <marcel@holtmann.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <AsKNxFx2juN.A.bxC.BJn2JB@chimera>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.bxC.BJn2JB@chimera>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 09:14:51 +0200
Message-Id: <1239088491.19390.25.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12499
> Subject		: Problem with using bluetooth adaper connected to usb port
> Submitter	: "Maciej Rutecki" <maciej.rutecki@gmail.com>
> Date		: 2009-01-13 18:34 (84 days old)
> References	: http://marc.info/?l=linux-kernel&m=123187185426236&w=4

I prefer to have this checked against 2.6.30-rc1 once Linus released
that one. I think that I know the root cause for this one and it is
actually a hardware/firmware bug. Some Bluetooth dongles expect to have
the interrupt and bulk URBs available at the same time. Otherwise they
do pee in their pants.

Regards

Marcel


