Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYBZI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYBZI23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYBZI2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:28:21 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:51135 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYBZI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:28:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hArOAjEmYD10PgWRg8nD9eDMvdKFR701ZuBrXsB3JrNBpn0NfGn67hSHsFuafKJBRqUtBovoiZWRBHCEqM/avbImqhpza+Zrldrn9EBJuKVBMGYSmNQGR+MOd4a1TTpXLOEEn7TFZjKWPFaBjIeg/NzSNgnFLS/LquVxDwZBjBI=
Message-ID: <6278d2220802260028y7a4a7ac5o568fd1029ef9fd82@mail.gmail.com>
Date: Tue, 26 Feb 2008 08:28:18 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: linux-acpi@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc3] ACPI _PPC limiting processor speed...
Cc: "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080225154845.2b71c200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220802251329x75b6d4c5lc3fab6fe6e75363f@mail.gmail.com>
	 <20080225154845.2b71c200.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:48 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 25 Feb 2008 21:29:24 +0000 "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
>  > My 2.2GHz [1] Thinkpad T61 is unable to get past 1.2GHz, seemingly
>  > because of the _PPC ACPI objects [2].
>  >
>  > Given that the _PPC object is different for both cores, is this more
>  > of a BIOS bug or an ACPI interpreter problem? The problem was present
>  > in 2.6.24-rc, 2.6.24 final and since.
>  >
>  > BIOS is 7LETA9WW/2.09, so current - would any further information be
>  > useful for debugging this problem, and would dumping the ACPI tables
>  > be useful?
>  >
>  > Thanks,
>  >   Daniel
>  >
>  > --- [1]
>  >
>  > freq-table: table entry 0: 2201000 kHz, 0 index
>  > freq-table: table entry 1: 2200000 kHz, 1 index
>  > freq-table: table entry 2: 1600000 kHz, 2 index
>  > freq-table: table entry 3: 1200000 kHz, 3 index
>  > freq-table: table entry 4: 800000 kHz, 4 index
>  >
>  > --- [2]
>  >
>  > cpufreq-core: CPU 0: _PPC is 3 - frequency  limited
>  > cpufreq-core: CPU 1: _PPC is 0 - frequency not limited
>
>  (cc linux-acpi)
>
>  If nothing happens, please raise a report at bugzilla.kernel.org, thanks.

I've raised this into a Bugzilla entry for tracking and history, and
dumped ACPI tables in binary and hex formats:

http://bugzilla.kernel.org/show_bug.cgi?id=10110

Let me know of anything else useful. If I get time in the next days,
I'll try find a previous working kernel and start bisecting for the
regression.

Thanks,
  Daniel
-- 
Daniel J Blueman
