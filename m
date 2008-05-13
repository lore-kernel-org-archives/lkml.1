Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYEMKXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYEMKXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYEMKW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:22:58 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:56036 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752339AbYEMKW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:22:57 -0400
Message-ID: <48296C1B.2070808@suse.de>
Date: Tue, 13 May 2008 14:23:23 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: Move es7000_plat out of mpparse.c
References: <20080512152434.27570.7396.stgit@thinkpad> <20080513095528.GB24037@elte.hu> <20080513100214.GA1034@elte.hu>
In-Reply-To: <20080513100214.GA1034@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please drop second patch, I'll rework it.

Ingo Molnar wrote:
> x86.git testing found that this broke the build:
> 
> arch/x86/kernel/acpi/boot.c: In function 'mp_register_ioapic':
> arch/x86/kernel/acpi/boot.c:896: error: implicit declaration of function 'bad_ioapic'
> arch/x86/kernel/acpi/boot.c: In function 'mp_override_legacy_irq':
> arch/x86/kernel/acpi/boot.c:959: error: implicit declaration of function 'MP_intsrc_info'
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Tue_May_13_11_52_24_CEST_2008.bad
> 
> 	Ingo

