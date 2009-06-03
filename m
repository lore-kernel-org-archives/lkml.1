Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZFCAwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZFCAwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZFCAw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:52:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53731 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZFCAw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:52:27 -0400
Message-ID: <4A25C99B.40303@cn.fujitsu.com>
Date: Wed, 03 Jun 2009 08:53:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: +	cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.
 patch added to -mm tree
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org> <20090602090944.GB16753@linux.vnet.ibm.com> <6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com> <20090602174042.GD16753@linux.vnet.ibm.com>
In-Reply-To: <20090602174042.GD16753@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> On Tue, Jun 02, 2009 at 09:08:04AM -0700, Paul Menage wrote:
>> On Tue, Jun 2, 2009 at 2:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>>> I am not sure if this is a good idea. For libcgroup, we would then be
>>> adding a special case for just cpuset. I would rather that we allow it
>>> either for all the subsystems or none of them.
>>>
>> libcgroup shouldn't be using the noprefix option. Its only intentded
>> use is to allow the legacy "cpuset" filesystem type to be mounted and
>> to see the same fileset as it had before the cgroups transition.
>>
> 
> It does not. But if some user is using that option, we need to be in a
> position to handle it.
> 
> I am quite happy not supporting the noprefix option in the library if it
> is fine.
> 

I don't think we need to support noprefix in libcgroup.

Even if we decide to support noprefix in the lib, it shouldn't be harder
to handle noprefix+cpuset only than handle noprefix+any combination of
subsystems.


