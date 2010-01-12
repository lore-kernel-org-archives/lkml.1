Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426Ab0ALA3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0ALA3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270Ab0ALA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:29:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:46264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0ALA3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:29:52 -0500
Message-ID: <4B4BC2D3.7070003@kernel.org>
Date: Tue, 12 Jan 2010 09:31:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --  (s_active){++++.+},
 at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>	<2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>	<m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl> <m1wrzpbcmi.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrzpbcmi.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Jan 2010 00:29:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 11:26 AM, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> Date: Sun, 10 Jan 2010 18:13:35 -0800
> Subject: [PATCH] sysfs: Add support for lockdep subclasses to s_active
> 
> We have apparently valid cases where the code for a sysfs attribute
> removes other sysfs attributes.  Without support for subclasses
> lockdep flags a possible recursive lock problem as it figures
> the first sysfs attribute could be attempting to remove itself.
> 
> By adding support for sysfs subclasses we can teach lockdep to
> distinguish between different types of sysfs attributes and not
> get confused.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
