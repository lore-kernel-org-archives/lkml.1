Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYC0WAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYC0WAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbYC0WA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:00:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47474 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342AbYC0WA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:00:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7:  Ugh.
Date: Thu, 27 Mar 2008 23:00:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <47EBBD57.30902@rtr.ca>
In-Reply-To: <47EBBD57.30902@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803272300.24462.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Mark Lord wrote:
> It is with great reluctance when I attempt moving my main "desktop"
> over to a new kernel version -- because the USB subsystem seems to
> break every single time.
> 
> So today I tried 2.6.25-rc7 on it for the first time.
> Not good.
> 
> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
> It comes back on resume, with an X desktop again,
> but with no USB functionality -- no mouse.

Mark, could you try to boot with "acpi_new_pts_ordering" and retest?

Perhaps the problem is caused by the suspend ordering being wrong.

Thanks,
Rafael
