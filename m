Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbZKZK1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbZKZK1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbZKZK1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:27:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:39684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252AbZKZK1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:27:20 -0500
Subject: Re: [PATCH -tip 3/3] define nsecs_to_jiffies()
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <4B0E16E7.5070307@jp.fujitsu.com>
References: <4B061E9A.8040100@jp.fujitsu.com>
	 <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>
	 <4B0B714C.9080607@jp.fujitsu.com> <4B0B8683.6020104@jp.fujitsu.com>
	 <4B0E16E7.5070307@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 11:27:06 +0100
Message-ID: <1259231226.4273.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 14:49 +0900, Hidetoshi Seto wrote:
> Use of msecs_to_jiffies() for nsecs_to_cputime() have some problems:
> 
>  - The type of msecs_to_jiffies()'s argument is unsigned int, so
>    it cannot convert msecs greater than UINT_MAX = about 49.7 days.
>  - msecs_to_jiffies() returns MAX_JIFFY_OFFSET if MSB of argument
>    is set, assuming that input was negative value.  So it cannot
>    convert msecs greater than INT_MAX = about 24.8 days too.
> 
> This patch defines a new function nsecs_to_jiffies() that can deal
> greater values, and that can deal all incoming values as unsigned.

This looks good too,

Thanks Hidetoshi-san!
