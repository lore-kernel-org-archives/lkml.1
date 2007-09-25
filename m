Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXIYL3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXIYL3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXIYL3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:29:38 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:58712 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbXIYL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:29:38 -0400
Message-ID: <46F8F11A.6090500@suse.de>
Date: Tue, 25 Sep 2007 15:29:30 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Daniel Ritz <daniel.ritz@gmx.ch>
CC: linux-kernel@vger.kernel.org, Damien Wyart <damien.wyart@free.fr>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       akpm@linux-foundation.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925110220.189530@gmx.net>
In-Reply-To: <20070925110220.189530@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel, thanks for the patch, but patch for solving your issue is already done.
And it is different from one we having here.

If you feel "patchy" today you may try to remove ACPI_SLEEP from 
drivers/acpi/sleep/Makefile in the raw of main.o

Regards,
Alex.

Daniel Ritz wrote:
> does that one help?
> 
> [ as attachment since i'm on webmail ]
> 
> ACPI: acpi_sleep_prepare() should not depent on CONFIG_SUSPEND
> Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

