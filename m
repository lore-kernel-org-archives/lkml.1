Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270Ab0APVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0APVDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 16:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702Ab0APVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 16:03:13 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:57063 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0APVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 16:03:12 -0500
Date: Sat, 16 Jan 2010 16:03:03 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rakib Mullick <rakib.mullick@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: Fix unused variable warning in sbs.c
In-reply-to: <4B488CFA.2070304@suse.de>
Message-id: <alpine.LFD.2.00.1001161602070.7124@localhost.localdomain>
References: <b9df5fa11001030527h71b66dbcgd4ef29c04545cdaf@mail.gmail.com>
 <20100107145126.22271109.akpm@linux-foundation.org> <4B488CFA.2070304@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-871842010-1263675784=:7124"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-871842010-1263675784=:7124
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 9 Jan 2010, Alexey Starikovskiy wrote:

> Andrew Morton пишет:
> > I wonder if it can be fixed in Kconfig.  Is there any sane use of
> > this code when CONFIG_ACPI_SYSFS_POWER=n && CONFIG_ACPI_PROCFS_POWER=n?

> No, this driver is useless in such a case. It can not output any info (and this is all it does).


Hi Alex,
Probably the code can lose some ifdefs by doing things
like making acpi_battery_remove_fs() a static inline when 
!CONFIG_ACPI_PROCFS_POWER.

cheers,
-Len

--8323328-871842010-1263675784=:7124--
