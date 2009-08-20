Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZHTDMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZHTDMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZHTDMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:12:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53479 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbZHTDMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:12:44 -0400
Message-ID: <4A8CBEDC.6010709@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 11:11:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>	 <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>	 <4A8CB62F.8030504@cn.fujitsu.com> <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com>
In-Reply-To: <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Aug 19, 2009 at 7:34 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> It's sure that reverting this commit makes things easier, but
>> rebasing this patchset shouldn't be hard. And this doesn't
>> sound a good reason to revert an innocent commit.
>>
> 
> The problem is that Ben's patch set starts with a patch that adds the
> "procs" file, and then a patch that fixes the namespace bug, and he
> and you used different names for variables/functions even though you
> were doing essentially the same thing. So rebasing would involve
> pretty much entirely rewriting the first patch and ditching the second
> - not just a case of fixing up some merge conflicts.
> 

Here we reintroduce the bug, and re-fix it with the essentially
same solution, this lazy way doesn't sound right to me.

As you said, the 2 patches differ just in using different var/func
names, so rebasing shouldn't be hard but maybe a bit boring.

