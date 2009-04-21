Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZDUKTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZDUKTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZDUKTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:19:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33457 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbZDUKTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:19:44 -0400
Message-ID: <2fdd7e9df2c0b9380a0b1fcdedafecf7.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090421095525.GA13699@linux>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com>
    <1240090712-1058-3-git-send-email-righi.andrea@gmail.com>
    <20090421091534.971f676f.kamezawa.hiroyu@jp.fujitsu.com>
    <20090421095525.GA13699@linux>
Date: Tue, 21 Apr 2009 19:19:39 +0900 (JST)
Subject: Re: [PATCH 2/7] res_counter: introduce ratelimiting attributes
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Andrea Righi" <righi.andrea@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Gui Jianfeng" <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       "Carl Henrik Lunde" <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       "Divyesh Shah" <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, "Hirokazu Takahashi" <taka@valinux.co.jp>,
       "Li Zefan" <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, "Ryo Tsuruta" <ryov@valinux.co.jp>,
       "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, "Nauman Rafique" <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> On Tue, Apr 21, 2009 at 09:15:34AM +0900, KAMEZAWA Hiroyuki wrote:

>> It's very bad if cacheline of spinlock is different from data field, in
>> future.
>
> Regarding the new attributes, policy can be surely an unsigned int or
> even less (now only 1 bit is used!), maybe we can just add an unsigned
> int flags, and encode also potential future informations there.
agreed.

>
> Moreover, are we sure we really need an unsigned long long for failcnt?
>
I think "int" is enough for failcnt.

Thanks,
-Kame

