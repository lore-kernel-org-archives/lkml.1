Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZKFNhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZKFNhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbZKFNhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:37:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbZKFNhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:37:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to unlocked_ioctl
Date: Fri, 6 Nov 2009 14:37:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org
References: <20091015202722.372890083@linutronix.de> <200911061422.49596.arnd@arndb.de> <4AF42672.7040501@redhat.com>
In-Reply-To: <4AF42672.7040501@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061437.06978.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18PQS23q/fxtoRIN7fpTIMHYvwhQIZUC+lfM/G
 KV+s5Ybo+NBylIgqLX4Wv4OT9rnQvF+nt3+k4eZ/HFL8EOpfKv
 x1G8LoQftu8hk3TQuR86Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009, Hans de Goede wrote:
> Moving the ident struct to the data structure would have it needlessly
> using RAM all the time, the best and simplest fix for this is to simply
> stop declaring ident static inside the ioctl function.

Ok. Considering the case of multiple watchdogs in the system, that seems
best then. Of course, the watchdog infrastructure does not allow this
right now, but it may be added at some point.

	Arnd <><
