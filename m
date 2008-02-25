Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbYBYXuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbYBYXuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYBYXuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:50:11 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbYBYXuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:50:06 -0500
Date: Mon, 25 Feb 2008 15:48:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc3] ACPI _PPC limiting processor speed...
Message-Id: <20080225154845.2b71c200.akpm@linux-foundation.org>
In-Reply-To: <6278d2220802251329x75b6d4c5lc3fab6fe6e75363f@mail.gmail.com>
References: <6278d2220802251329x75b6d4c5lc3fab6fe6e75363f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 21:29:24 +0000 "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:

> My 2.2GHz [1] Thinkpad T61 is unable to get past 1.2GHz, seemingly
> because of the _PPC ACPI objects [2].
> 
> Given that the _PPC object is different for both cores, is this more
> of a BIOS bug or an ACPI interpreter problem? The problem was present
> in 2.6.24-rc, 2.6.24 final and since.
> 
> BIOS is 7LETA9WW/2.09, so current - would any further information be
> useful for debugging this problem, and would dumping the ACPI tables
> be useful?
> 
> Thanks,
>   Daniel
> 
> --- [1]
> 
> freq-table: table entry 0: 2201000 kHz, 0 index
> freq-table: table entry 1: 2200000 kHz, 1 index
> freq-table: table entry 2: 1600000 kHz, 2 index
> freq-table: table entry 3: 1200000 kHz, 3 index
> freq-table: table entry 4: 800000 kHz, 4 index
> 
> --- [2]
> 
> cpufreq-core: CPU 0: _PPC is 3 - frequency  limited
> cpufreq-core: CPU 1: _PPC is 0 - frequency not limited

(cc linux-acpi)

If nothing happens, please raise a report at bugzilla.kernel.org, thanks.
