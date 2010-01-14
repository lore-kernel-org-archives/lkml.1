Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917Ab0ANJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab0ANJcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973Ab0ANJcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:32:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42194 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0ANJcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Dchdt0EnDp0ry0hH/9/34owc67GDh1X3cKwlT7RFB0F7futQ8TghcT3+cicPcieB2o
         k/tlv9DZKtng4qp17vtUC3kmTs/9coGNwGpuvGAycNAszy3BkV2Mdyjl2rTsW+Jk2PPX
         VMVYz9BZ+xbJBSo2fw65IC1WuwdgFtMgrLty0=
MIME-Version: 1.0
In-Reply-To: <20100112092106.9ac4e535.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091231051050.GA714@andrew.cmu.edu>
	 <20100106160414.bd555474.akpm@linux-foundation.org>
	 <20100107012606.GA25577@andrew.cmu.edu>
	 <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
	 <4B45824B.9030108@cn.fujitsu.com>
	 <20100108052734.GA13168@andrew.cmu.edu>
	 <20100108053021.GC13168@andrew.cmu.edu>
	 <20100108151038.GA22219@redhat.com>
	 <20100112092106.9ac4e535.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 14 Jan 2010 15:02:09 +0530
Message-ID: <661de9471001140132o23f44a4fjb1849d865f96d19a@mail.gmail.com>
Subject: Re: [RFC] [PATCH 2/2] cgroups: blkio subsystem as module
From: Balbir Singh <bsingharora@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       axboe@kernel.dk, ryov@valinux.co.jp,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 5:51 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 8 Jan 2010 10:10:38 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> On Fri, Jan 08, 2010 at 12:30:21AM -0500, Ben Blum wrote:
>> > Convert blk-cgroup to be buildable as a module
>> >
>> > From: Ben Blum <bblum@andrew.cmu.edu>
>> >
>> > This patch modifies the Block I/O cgroup subsystem to be able to be built as a
>> > module. As the CFQ disk scheduler optionally depends on blk-cgroup, config
>> > options in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
>> > enhanced to support the new module dependency.
>> >
>>
>> Hi Ben,
>>
>> I will give this patch a try.
>>
>> So from blk-cgroup perspective, the advantage of allowing it as module
>> will be that we can save some memory if we are not using the controller?
>>
> Is "moduled" blkio cgroup safe after page-tracking by page_cgroup is
> introduced ?
>

My guess is it won't be, unless we start exposing page_cgroup API and
then make the module depend on memcg.

Balbir
