Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYEEQzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYEEQzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYEEQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:55:09 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:5723 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841AbYEEQzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:55:08 -0400
From: Frans Pop <elendil@planet.nl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 18:55:04 +0200
User-Agent: KMail/1.9.9
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <86802c440805041323s1484a8ecx5dbe639d658d015b@mail.gmail.com>
In-Reply-To: <86802c440805041323s1484a8ecx5dbe639d658d015b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805051855.05496.elendil@planet.nl>
X-OriginalArrivalTime: 05 May 2008 16:55:06.0128 (UTC) FILETIME=[C4FB1900:01C8AED0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, Yinghai Lu wrote:
> can you boot with pat=off and send out /proc/mtrr?

Hmmm. Is 'pat=off' supposed to do anything?

With a default boot I see:
kernel: Command line: root=/dev/mapper/main-root ro vga=791
[...]
kernel: x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106

And with 'pat=off' I get the same:
kernel: Command line: root=/dev/mapper/main-root ro vga=791 pat=off
[...]
kernel: x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106

Anyway, the info in /proc/mtrr is identical with and without the option, and 
is also identical to what I get with 2.6.25.1:

$ cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x7f800000 (2040MB), size=   8MB: uncachable, count=1
reg02: base=0x7f700000 (2039MB), size=   1MB: uncachable, count=1
reg03: base=0x80000000 (2048MB), size= 256MB: write-combining, count=1

Cheers,
FJP
