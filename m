Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbXJWX1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbXJWX1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXJWX0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:26:55 -0400
Received: from gw.goop.org ([64.81.55.164]:52609 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXJWX0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:26:54 -0400
Message-ID: <471E833B.6070602@goop.org>
Date: Tue, 23 Oct 2007 16:26:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org> <471E7B1D.4050107@zytor.com>
In-Reply-To: <471E7B1D.4050107@zytor.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Furthermore, on looking through the code again, I see a bunch of
> "init_pg_tables_end + setup_data_len" which really is ugly.

Yeah, that's what I'm objecting to.

>> What are the alignment rules for this structure?  Is it always 64-bit
>> aligned?  What about the relationship of len and data?
>>
>
> It's x86, so alignment is soft - it presumably *should* be 64-bit
> aligned, but nothing break if the boot loader doesn't.

This was more or less a rhetorical question - the code spends some
effort in rounding len up to some alignment, so its probably worth
documenting with the structure.


    J
