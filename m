Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYBYTnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYBYTnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYBYTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:42:53 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:44699 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755387AbYBYTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:42:52 -0500
Message-ID: <47C31A1E.7080305@suse.de>
Date: Mon, 25 Feb 2008 22:42:22 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on
 thinkpad T61p
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
In-Reply-To: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
> such as Fn-F4 and lid open/close, prints them in /var/log/acpid
> and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).
> 
> This no longer happens in 2.6.25-rc3: I see nothing in /var/log/acpid
> after power on:
> [Mon Feb 25 20:47:28 2008] completed event "button/power PWRF 00000080 00000001"
> [Mon Feb 25 20:48:44 2008] starting up
> [Mon Feb 25 20:48:44 2008] 57 rules loaded
> [Mon Feb 25 20:48:48 2008] client connected from 5927[0:0]
> [Mon Feb 25 20:48:48 2008] 1 client rule loaded
> 
> and pressing buttons or closing lid produces no output in
> /var/log/acpid and seems to have no effect.
> 
> git bisect pointed at commit 208c70a45624400fafd7511b96bc426bf01f8f5e :
> ACPI: EC: Use proper handle for boot EC
> 
> If I do git revert 208c70a45624400fafd7511b96bc426bf01f8f5e on top
> of 2.6.25-rc3, I start getting keyboard acpi events, again.
Could you please create a bug report and attach acpidump?

Thanks,
Alex.
> 
> 
> Thanks,
> MST
> 
> PS: I see a different problem on resume, it seems to be unrelated to ACPI
> and I will bisect and report separately.
> 
> PPS: Pls Cc me directly, I am not on the list.

