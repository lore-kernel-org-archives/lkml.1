Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZKCCm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZKCCm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 21:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbZKCCm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 21:42:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50157 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbZKCCm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 21:42:57 -0500
Message-ID: <4AEF987A.5090308@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 10:42:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: bblum@andrew.cmu.edu, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/3] cgroups: support for module-loadable subsystems
References: <20091102212825.GA13692@andrew.cmu.edu>	 <4AEF8F7E.1000007@cn.fujitsu.com> <6599ad830911021811n7ccf7a70y6939ac581381c22f@mail.gmail.com>
In-Reply-To: <6599ad830911021811n7ccf7a70y6939ac581381c22f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Nov 2, 2009 at 6:03 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> I doubt the value of module-loadable subsystems. A cgroup subsystem
>> is usually a kernel resource controller, and normally it needs to
>> add some hooks in some in-kernel structures and functions, which
>> makes it impossible to be a module.
> 
> Not true - as the classifier example shows, if there's already a
> framework that supports hooking loadable modules into some kernel
> system, a resource controller can be a module.
> 

True. Just reminds me a pure cfq-based io controller can be a
module too, though the io controller discussed in the mini summit
won't be a pure cfq-based one.

>> In fact, net_cls is the only subsystem that can be a module, and
>> make it a module doesn't seem to have real benefit?
> 
> Wouldn't it be just as useful as any other module-loadable classifier,
> of which there are quite a few?
> 
> It's true that net_cls is currently the only subsystem that makes
> sense to use as a module, but its existence shows that the concept
> isn't too outlandish.
> 

Yes, sounds reasonable. 
