Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZEZQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZEZQim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZEZQif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:38:35 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:28539 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734AbZEZQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:38:34 -0400
Message-ID: <4A1C1B08.2080600@panasas.com>
Date: Tue, 26 May 2009 19:38:32 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug #13175] sata_nv incompatible with async scsi scan
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.NgD.lQcGKB@chimera>
In-Reply-To: <WCcYF-TAbJC.A.NgD.lQcGKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2009 16:38:34.0585 (UTC) FILETIME=[696D2490:01C9DE20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May. 24, 2009, 22:31 +0300, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).

Verified to still exist with 2.6.30-rc7 :-(

[The bug description is misleading though.  More testing
lead to post-kernel boot problems where initrd cannot find the sata
devices during its init phase]

Benny

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13175
> Subject		: sata_nv incompatible with async scsi scan
> Submitter	: Benny Halevy <bhalevy@panasas.com>
> Date		: 2009-04-21 7:03 (34 days old)
> References	: http://marc.info/?l=linux-kernel&m=124029746431777&w=4
> 
> 
