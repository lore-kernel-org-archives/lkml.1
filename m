Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0CICHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:07:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:57156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab0CICHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:07:15 -0500
Message-ID: <4B95AD17.2030106@kernel.org>
Date: Tue, 09 Mar 2010 11:06:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain> <84144f021003080529w1b20c08dmf6871bd46381bc71@mail.gmail.com>
In-Reply-To: <84144f021003080529w1b20c08dmf6871bd46381bc71@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 02:06:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 10:29 PM, Pekka Enberg wrote:
> On Mon, Mar 8, 2010 at 11:21 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> __zone_pcp_update() iterates over NR_CPUS instead of limiting the
>> access to the possible cpus. This might result in access to
>> uninitialized areas as the per cpu allocator only populates the per
>> cpu memory for possible cpus.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Looks OK to me.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Yeap, that's buggy.

Acked-by: Tejun Heo <tj@kernel.org>

I suppose this would go through the mm tree?

Thanks.

-- 
tejun
