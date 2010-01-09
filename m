Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639Ab0AIOEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0AIOEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128Ab0AIOEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:04:46 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:38256 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754103Ab0AIOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:04:45 -0500
Message-ID: <4B488CFA.2070304@suse.de>
Date: Sat, 09 Jan 2010 17:04:42 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rakib Mullick <rakib.mullick@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] acpi: Fix unused variable warning in sbs.c
References: <b9df5fa11001030527h71b66dbcgd4ef29c04545cdaf@mail.gmail.com> <20100107145126.22271109.akpm@linux-foundation.org>
In-Reply-To: <20100107145126.22271109.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton пишет:
> I wonder if it can be fixed in Kconfig.  Is there any sane use of
> this code when CONFIG_ACPI_SYSFS_POWER=n && CONFIG_ACPI_PROCFS_POWER=n?
No, this driver is useless in such a case. It can not output any info (and this is all it does).

Regards,
Alex.
