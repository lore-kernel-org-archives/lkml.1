Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYCRLrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYCRLrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYCRLrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:47:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42248 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYCRLrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:47:17 -0400
Date: Tue, 18 Mar 2008 11:02:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/3] PM: New suspend and hibernation callbacks for
	platform bus type
Message-ID: <20080318100220.GB10830@elf.ucw.cz>
References: <200803170020.55473.rjw@sisk.pl> <200803170024.23451.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803170024.23451.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-17 00:24:22, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Implement new suspend and hibernation callbacks for the platform bus
> type.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK... but... this is getting quite big:

>  drivers/base/platform.c         |  444 ++++++++++++++++++++++++++++++++++++++--
>  include/linux/platform_device.h |    2

...I hope cleanups in drivers are worth it...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
