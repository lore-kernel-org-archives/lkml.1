Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbZLQNMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbZLQNMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbZLQNMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:12:48 -0500
Received: from poutre.nerim.net ([62.4.16.124]:62342 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934204AbZLQNMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:12:47 -0500
Date: Thu, 17 Dec 2009 14:12:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to 
 unlocked_ioctl
Message-ID: <20091217141243.770dba04@hyperion.delvare>
In-Reply-To: <alpine.LFD.2.00.0911061655060.12138@localhost.localdomain>
References: <20091015202722.372890083@linutronix.de>
	<20091015202758.400949170@linutronix.de>
	<20091106141542.12404c5c@hyperion.delvare>
	<alpine.LFD.2.00.0911061655060.12138@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, 6 Nov 2009 16:56:34 +0100 (CET), Thomas Gleixner wrote:
> On Fri, 6 Nov 2009, Jean Delvare wrote:
> > I'm not sure why we need to hold the mutex here? My understanding is
> > that watchdog_data_mutex protects watchdog_data_list and each
> > watchdog's kref. And the above code doesn't touch either.
> > 
> > What I am more worried about is why ident is declared static. This
> > looks like a bug to me. Instead of abusing watchdog_data_mutex to
> > workaround this, I'd rather remove the "static". I guess that the
> > current code happens to work because neither data->revision nor
> > nowayout can change over time, but this looks needlessly fragile.
> 
> Right, we can change ident to be non static instead of abusing the
> mutex. Stupid me. Will fix.

This was quite some time ago and I can't seem to find an updated version
of your patch that I could apply. Care to send one?

Thanks,
-- 
Jean Delvare
