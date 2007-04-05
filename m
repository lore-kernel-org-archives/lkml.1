Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbXDEOb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbXDEOb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXDEOb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:31:59 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:33915 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbXDEOb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:31:58 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <461508C2.9000207@amd.com>
Date: Thu, 05 Apr 2007 16:33:38 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070304)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Fr??d??ric Riss" <frederic.riss@gmail.com>,
       "Tino Keitel" <tino.keitel@gmx.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, pavel@suse.cz,
       linux-pm@lists.osdl.org, "Soeren Sonnenburg" <kernel@nn7.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>, maximlevitsky@gmail.com,
       cijoml@volny.cz
Subject: Re: [4/4] 2.6.21-rc5: known regressions (v2)
X-OriginalArrivalTime: 05 Apr 2007 14:31:26.0250 (UTC)
 FILETIME=[178D18A0:01C7778F]
X-WSS-ID: 6A0BD7C82EW3255660-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject    : USB: Oops when changing DVB-T adapter
References : http://lkml.org/lkml/2007/3/9/212
Submitter  : CIJOML <cijoml@volny.cz>
Status     : unknown

regarding this one there's a fix available for unplugging dvb devices 
when they're in still in use.
The problem was that the filehandle was still open and the fops 
structure got deallocated immediatelly when a device got unplugged.

http://mcentral.de/hg/~mrec/v4l-dvb-stable/ (the last 3 patches)

Markus


On 4/1/07, Michael S. Tsirkin <mst@dev.mellanox.co.il> wrote:
 > > Subject    : after resume: X hangs after drawing a couple of windows
 > >              workaround: clocksource=acpi_pm
 > > References : http://lkml.org/lkml/2007/3/8/117
 > >              http://lkml.org/lkml/2007/3/25/20
 > >              http://lkml.org/lkml/2007/3/26/151
 > > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
 > > Handled-By : Thomas Gleixner <tglx@linutronix.de>
 > > Status     : problem is being debugged
 >
 > Seems to be resolved with 399afa4fc9238fbae42116cf25a54671c0e8f56e.
 > Thanks Maxim!
 >
 >
 > --
 > MST
 > -
 > To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
 >


-- 
Markus Rechberger

-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG



