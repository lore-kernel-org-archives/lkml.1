Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXC2JKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXC2JKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXC2JKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:10:17 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:32415 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXC2JKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:10:15 -0400
Date: Thu, 29 Mar 2007 11:12:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg K-H <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Eric Rannaud <eric.rannaud@gmail.com>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [Patch -mm 0/3] uevent_suppress handling.
Message-ID: <20070329111206.239991b8@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following up on the firmware loading problems in 2.6.21-rc4-mm1, I've
been looking into uevent_suppress and using it in the firmware class.
As an added bonus, I also managed to suppress some unwanted uevents on
s390.

Works for me on i386 (the firmware stuff) and on s390 (the subchannel
stuff).

Patches are against 2.6.21-rc5-mm1.

[1/3] Driver core: suppress uevents via filter.
[2/3] Driver core: switch firmware_class to uevent_suppress.
[3/3] s390: cio: Delay uevents for subchannels.
