Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZFHHET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZFHHET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZFHHEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:04:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34938 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZFHHED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:04:03 -0400
Message-ID: <4A2CB7AE.6080909@gmail.com>
Date: Mon, 08 Jun 2009 10:03:10 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] writeback: skip new or to-be-freed inodes
References: <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz> <20090603144711.GC5738@localhost> <20090606030725.GA12852@localhost>
In-Reply-To: <20090606030725.GA12852@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jun 2009 07:03:18.0391 (UTC) FILETIME=[338AA870:01C9E807]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> The above race and warning didn't turn up because writeback_inodes() holds
> the s_umount lock, so generic_forget_inode() finds MS_ACTIVE and returns
> early. But we are not sure the UBIFS calls and future callers will guarantee
> that. So skip I_WILL_FREE inodes for the sake of safety.

The inode states are a bit vague for me, but vs. UBIFS - feel
free to ask questions.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
