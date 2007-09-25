Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbXIYQ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbXIYQ0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXIYQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:25:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12667 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbXIYQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:25:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CmdF35iwdltE2bUVIyfqkLJ6GaY2q2Sg0mZvDzDmg994PTDBDaY/xekxpLoySBdlGbqkn+9PDzidGc3wgYhWc7+XucuxfdWqKIhv2i0FmYVrmzX1B6Moe+C1IXnXJzgjtnRVWLXp5fAKkWNDOeUMU9jEXMVA1h47A6GxZpiXGMQ=
Message-ID: <46F9368A.40604@gmail.com>
Date: Tue, 25 Sep 2007 20:25:46 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Damien Wyart <damien.wyart@free.fr>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain>	<200709251618.06064.rjw@sisk.pl>	<46F918F8.1080808@suse.de>	<200709251652.05589.rjw@sisk.pl>	<46F91EFB.2050802@suse.de> <20070925092323.17442600.akpm@linux-foundation.org>
In-Reply-To: <20070925092323.17442600.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

There are 2 patches, this is the second.
Above, Rafael gave link to first. Here it is again:
http://marc.info/?l=linux-kernel&m=119052978117735&w=4

Sorry for confusion,
Alex.

Andrew Morton wrote:
> On Tue, 25 Sep 2007 18:45:15 +0400 Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> 
>> [fix-ACPI_SLEEP_states.patch  text/x-patch (2.0KB)]
>> ACPI: suspend: fix ACPI_SLEEP states
>>
>> From: Alexey Starikovskiy <astarikovskiy@suse.de>
>>
>> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>> ---
>>
>>  drivers/acpi/sleep/Makefile |    2 +-
>>  drivers/acpi/sleep/main.c   |    4 ++++
>>  include/acpi/acpi_drivers.h |    4 ----
>>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> I get a reject applying this to current mainline.  Easy enough to fix it,
> but I worry that the fix might be incorrect when applied to some tree other
> than that which you were working on.
> 
> 

