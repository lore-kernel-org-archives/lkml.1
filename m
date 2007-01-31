Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXAaIkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXAaIkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbXAaIkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:40:25 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:14814 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXAaIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:40:24 -0500
Date: Wed, 31 Jan 2007 09:40:14 +0100 (MET)
From: Oliver Neukum <oliver@neukum.name>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: question on resume()
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, nigel@nigel.suspend2.net,
       pm list <linux-pm@lists.osdl.org>
References: <200701291206.39637.oneukum@suse.de>
 <200701302332.26063.rjw@sisk.pl> <200701310933.29443.rjw@sisk.pl>
In-Reply-To: <200701310933.29443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701310940.26040.oliver@neukum.name>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Januar 2007 09:33 schrieb Rafael J. Wysocki:
> On Tuesday, 30 January 2007 23:32, Rafael J. Wysocki wrote:

> > Generally, you are safe if your driver only calls wake_up() from a process
> > context, but not from .resume() or .suspend() routines (or from an
> > unfreezeable kernel thread).
> 
> Ah, sorry, I've just realized I was wrong.  Processes in TASK_UNINTERRUPTIBLE
> cannot be frozen!  So, the above only applies to wake_up_interruptible().

So the kernel will wait for tasks in TASK_UNINTERRUPTIBLE to finish IO
before it calls suspend()? I am confused.

	Regards
		Oliver
