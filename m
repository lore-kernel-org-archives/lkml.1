Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZI2APf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZI2APf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZI2APf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:15:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbZI2APd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:15:33 -0400
Message-ID: <4AC15197.9010105@kernel.org>
Date: Tue, 29 Sep 2009 09:15:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu: fix unit_map[] verification in pcpu_setup_first_chunk()
References: <4ABAC2F1.3020302@kernel.org>	 <1254055797.2756.1.camel@localhost>  <4AC0E201.2020006@kernel.org> <1254175662.2783.1.camel@localhost>
In-Reply-To: <1254175662.2783.1.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 29 Sep 2009 00:15:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> On Tue, 2009-09-29 at 01:19 +0900, Tejun Heo wrote:
>> pcpu_setup_first_chunk() incorrectly used NR_CPUS as the impossible
>> unit number while unit number can equal and go over NR_CPUS with
>> sparse unit map.  This triggers BUG_ON() spuriously on machines which
>> have non-power-of-two number of cpus.  Use UINT_MAX instead.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Tony Vroon <tony@linx.net>
> Tested-by: Tony Vroon <tony@linx.net>
> 
>> Erghh... stupid mistake.  This should fix it.  Can you please verify?
> 
> Confirmed fixed. Thank you Tejun.

Thank you.  Will push out later today.

-- 
tejun
