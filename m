Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXJaUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXJaUKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXJaUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:09:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbXJaUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:09:55 -0400
Message-ID: <4728E0DE.7080702@zytor.com>
Date: Wed, 31 Oct 2007 13:09:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Huang, Ying" <ying.huang@intel.com>, tglx@linutronix.de, mingo@redhat.com,
       torvalds@linux-foundation.org, adaplas@pol.net, ak@suse.de,
       ebiederm@xmission.com, mouli@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
References: <1193218342.23935.147.camel@caritas-dev.intel.com>	<1193793701.23935.394.camel@caritas-dev.intel.com> <20071031125907.ba953d4a.akpm@linux-foundation.org>
In-Reply-To: <20071031125907.ba953d4a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I stopped paying attention, sorry.  Have all the outstanding issues been
> addressed?

The "EFI boot" patchset looks fairly unobtrusive to me.  One objection: 
the VIDEO_TYPE_ numbers appear split up into groups; and the EFI one 
probably should be 0x70 instead of 0x24.

Other than that, I just need to verify it doesn't break anything.

"EFI runtime" I have not had time to review yet.

	-hpa

