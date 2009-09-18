Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZIRCZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZIRCZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZIRCZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:25:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:36395 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZIRCZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ljsDylp2zqjVW9qCQGktv4hEBWhZ3WyRZa1/kmx8z04bx3zPHc5d4AXndlAVvzCdPG
         +GpS78BQpCDNUsNjC1O6TASF9hxjsoCArtNgxG3QcoqmTULLTpT0m5mskxxN3XyahhRk
         cukE9kcj3H3rmpPAvQT7i2jWr6hZWRNje/3uk=
MIME-Version: 1.0
In-Reply-To: <20090918090200.a1810a9b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917150726.9acb0f40.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917062124.GA6964@localhost>
	 <20090917155100.3cc2dfb6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917071428.GA9232@localhost>
	 <20090917162324.d60a7950.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917094203.GA13885@localhost>
	 <b756a8e49c515a5ada93ac90d1076056.squirrel@webmail-b.css.fujitsu.com>
	 <20090917124039.GB9462@localhost>
	 <20090918090200.a1810a9b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 18 Sep 2009 10:25:16 +0800
Message-ID: <2375c9f90909171925i5c148f39yfe9d54807f5645eb@mail.gmail.com>
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling v4
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "oleg@redhat.com" <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 8:02 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 17 Sep 2009 20:40:39 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
>
>> > >         if (pos + count < pos)
>> > >                 return -EOVERFLOW;
>> > >         ...
>> > > }
>> > >
>> > have to avoid pos == LONGLONGMAX case.
>>
>> Ah sorry, didn't know loff_t could be long long..
>>
> Thank you. I'll restart this after merge window.
> (And maybe I had to CC fsdevel...)

Yes, please do so. I would like to hear from Al..
