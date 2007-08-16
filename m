Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbXHPONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbXHPONv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbXHPONl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:13:41 -0400
Received: from 87-127-95-196.no-dns-yet.enta.net ([87.127.95.196]:34356 "EHLO
	oxford.xeocode.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759481AbXHPONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:13:40 -0400
X-Greylist: delayed 2240 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 10:13:40 EDT
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: soft lockup detected
In-Reply-To: <1187270275.6114.87.camel@twins> (Peter Zijlstra's message of "Thu\, 16 Aug 2007 15\:17\:55 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
X-Draft-From: ("nnimap+mail01.enterprisedb.com:INBOX" 31969)
References: <87ps1nx3kl.fsf@oxford.xeocode.com>
	<1187270275.6114.87.camel@twins>
From: Gregory Stark <stark@enterprisedb.com>
Organization: EnterpriseDB
Date: Thu, 16 Aug 2007 14:36:17 +0100
Message-ID: <874pizwqi6.fsf@oxford.xeocode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter Zijlstra" <peterz@infradead.org> writes:

> On Thu, 2007-08-16 at 09:54 +0100, Gregory Stark wrote:
>
>> This is on 2.6.21-1.3194.fc7. I've been trying different kernels but this is
>> the first point where I've narrowed down the symptoms to something
>> reproducible.
>
> That is a very old kernel, and a vendor kernel at that.

I'm sorry? The original kernel to exhibit the problem was 2.6.5 -- *that* was
a very old kernel and I insisted we upgrade before trying to report any
problems. However 2.6.21 is only one version out of date and it's about 3
months old. None of the changelog entries since then have mentioned any semop
or ipc related changes (aside from a hugetlb change but we're not using
hugetlb). It's more recent than most distributions have as their current
release.

I do share your feelings about vendor kernels. We've seen these problems with
SUSE 2.6.5 and 2.6.16 kernels though. This was the most recently released
kernel we've tried.

> Did any of the different kernels you tried include a recent upstream
> one?

Still working on it.

-- 
  Gregory Stark
  EnterpriseDB          http://www.enterprisedb.com
