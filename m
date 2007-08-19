Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbXHSR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbXHSR7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXHSR7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 13:59:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:45212 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbXHSR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 13:59:09 -0400
Message-ID: <46C884DF.4080101@suse.de>
Date: Sun, 19 Aug 2007 21:58:55 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Alex Hunsaker <badalex@gmail.com>
CC: len.brown@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [ACPI] Regression 2.6.23-rc3 fails to boot (acpi)
References: <34d269d40708190145m7a17ed35g190f0a5fabc4776e@mail.gmail.com>
In-Reply-To: <34d269d40708190145m7a17ed35g190f0a5fabc4776e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What machine is it?
Could you open a bug at bugzilla.kernel.org and append acpidump output
to it?

Thanks,
Alex.

Alex Hunsaker wrote:
> Hangs on boot with:
> ACPI: EC: GPE = 0x4, I/O: command/status = 0x66, data = 0x62
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3)
> ACPI: Using PIC for interrupt routing
> ACIP: EC: GPE = 0x4, I/O: command/status = 0x66, data = 0x62
>
> 2.6.23-rc2 is ok
> 2.6.23-rc3 bad
> 2.6.23-rc3-latest (7c010de7506954e973abfab5c5999c5a97f7a73e) bad
>
> git-bisect narrowed it down to:
>
> 7c010de7506954e973abfab5c5999c5a97f7a73e
> ACPI: EC: Switch from boot_ec as soon as we find its desc in DSDT.
> Alexey Starikovskiy [Fri, 3 Aug 2007 21:57:53 +0000 (17:57 -0400)]
> Some ASUS laptops fail to use boot time EC
> and need to eventually switch to one described in DSDT.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=8709
>
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> Signed-off-by: Len Brown <len.brown@intel.com>
>
> Reverting the above commit fixes the problem.
>   

