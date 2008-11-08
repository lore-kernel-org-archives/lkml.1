Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYKHCgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYKHCgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYKHCfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:35:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40017 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYKHCfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:35:51 -0500
Message-ID: <36332.10.75.179.62.1226111748.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081107145036.GF21884@redhat.com>
References: <20081106153022.215696930@redhat.com>
    <20081106153135.869625751@redhat.com>
    <20081107122145.69500cd3.kamezawa.hiroyu@jp.fujitsu.com>
    <20081107145036.GF21884@redhat.com>
Date: Sat, 8 Nov 2008 11:35:48 +0900 (JST)
Subject: Re: [patch 3/4] io controller: Core IO controller 
     implementationlogic
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       "Hirokazu Takahashi" <taka@valinux.co.jp>,
       "Ryo Tsuruta" <ryov@valinux.co.jp>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>,
       "Rik van Riel" <riel@redhat.com>, fernando@oss.ntt.co.jp,
       "Jeff Moyer" <jmoyer@redhat.com>, menage@google.com, ngupta@google.com,
       "Andrew Morton" <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal said:
> On Fri, Nov 07, 2008 at 12:21:45PM +0900, KAMEZAWA Hiroyuki wrote:
>> On Thu, 06 Nov 2008 10:30:25 -0500
>> vgoyal@redhat.com wrote:
>>
>> >
>> > o Core IO controller implementation
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> >
>>
>> 2 comments after a quick look.
>>
>>  - I don't recommend generic work queue. More stacked dependency between
>> "work"
>>    is not good. (I think disk-driver uses "work" for their jobs.)
>
> Sorry, I did not get this. Are you recommending that don't create a new
> work queue, instead use existing work queue (say kblockd) to submit the
> bios
> here?
>
Ah, no, recomending new-original its own workqueue. I'm sorry that it seems
I missed something at reading your patch.
(other person may have other opinion, here;)

> I will look into it. I was little worried about a kblockd being overworked
> in case of too many logical devices enabling IO controller.
>

Thanks,
-Kame

