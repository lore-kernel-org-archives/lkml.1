Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXGCMog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXGCMog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXGCMo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:44:29 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:27874 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752913AbXGCMo2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:44:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: 2.6.21.5 june 30th to july 1st date hang?
Date: Tue, 3 Jul 2007 08:44:00 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21.5 june 30th to july 1st date hang?
Thread-Index: Ace9b9Q0ajy9G3UNTkCPl8PiFXbdoQ==
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Jul 2007 12:44:00.0997 (UTC) FILETIME=[D4A54950:01C7BD6F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

All my servers and workstations running a 2.6.21.5 kernel hanged exactly
when the date shift from june 30th to july 1st.

On my monitoring system every single station running a 2.6.21.5 kernel
stoped responding exactly after midnight on the date shift from June
30th to July 1st.  Although, stations still running 2.6.18 to 2.6.20.11
worked flawlessly.

I first tought there had been an electricity outage but two of my
servers (dell PE 2950 dual-quad core) on UPS in our server room also
hanged:
Jun 30 23:55:01 urpdev1 /USR/SBIN/CRON[31298]: (root) CMD ([ -x
/usr/lib/sysstat/sa1 ] && { [ -r "$DEFAULT" ] && . "$DEFAULT" ; [
"$ENABLED" = "true" ] && exec /usr/lib/sysstat/sa1; })
Jul  3 11:54:03 urpdev1 syslogd 1.4.1#17: restart.

I could not get anything on any of the 20+ consoles...  All the systems
hanged at around the exact same time... When the date shifted from June
30th to July 1st in UTC ...?

Any clue any one?

- vin
