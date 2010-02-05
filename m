Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab0BEHY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:24:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:35707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933310Ab0BEHY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:24:57 -0500
Message-ID: <4B6BC948.5030401@kernel.org>
Date: Fri, 05 Feb 2010 16:31:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: upcoming percpu changes
References: <20100205161648.086375b9.sfr@canb.auug.org.au> <4B6BB13C.2090108@kernel.org> <20100205070903.GA9320@elte.hu>
In-Reply-To: <20100205070903.GA9320@elte.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 07:24:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 02/05/2010 04:09 PM, Ingo Molnar wrote:
> Has the review feedback from Frederic and hpa been addressed? (and have they 
> acked the solution?) That was the only controversial bit i remember.

Al Viro said that, until sparse is improved, the only solution would
be to work around in the rather ugly way as posted in the original
patches.  As Frederic and hpa preferred not having the workaround and
there were only three instances in the kernel tree, I just left them
alone so sparse warning will trigger spuriously on those three
locations.

Thanks.

-- 
tejun
