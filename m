Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXGCNFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXGCNFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbXGCNFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:05:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbXGCNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:05:44 -0400
Message-ID: <468A4994.1060603@anagramm.de>
Date: Tue, 03 Jul 2007 15:05:24 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19WPkfNc7zLvfS/J7de8sRo1vl1fFZVCwAz1iq
 bkgInQATFP6xLgRg+Trqb9tz2DoocPb4bs4+43Bd9ELGCxwleq
 WbPpy4s6LJU2lVJeQnmnA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vincent!

Fortier,Vincent [Montreal] schrieb:
> Hi all,
> 
> All my servers and workstations running a 2.6.21.5 kernel hanged exactly
> when the date shift from june 30th to july 1st.
> 
> On my monitoring system every single station running a 2.6.21.5 kernel
> stoped responding exactly after midnight on the date shift from June
> 30th to July 1st.  Although, stations still running 2.6.18 to 2.6.20.11
> worked flawlessly.
> 
> I first tought there had been an electricity outage but two of my
> servers (dell PE 2950 dual-quad core) on UPS in our server room also
> hanged:
> Jun 30 23:55:01 urpdev1 /USR/SBIN/CRON[31298]: (root) CMD ([ -x
> /usr/lib/sysstat/sa1 ] && { [ -r "$DEFAULT" ] && . "$DEFAULT" ; [
> "$ENABLED" = "true" ] && exec /usr/lib/sysstat/sa1; })
> Jul  3 11:54:03 urpdev1 syslogd 1.4.1#17: restart.
> 
> I could not get anything on any of the 20+ consoles...  All the systems
> hanged at around the exact same time... When the date shifted from June
> 30th to July 1st in UTC ...?
> 
> Any clue any one?

No problems over here with plain 2.6.21.5 on x686

You could just reset the date back on one of these machines and
check the transition again... and see if it was really the kernel
who crashed.... and check your cron configuration.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
