Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbYBZJHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbYBZJHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYBZJHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:07:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbYBZJHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:07:23 -0500
Message-ID: <47C3D64A.6080709@cn.fujitsu.com>
Date: Tue, 26 Feb 2008 17:05:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller Add Boot Option
References: <20080225115509.23920.66231.sendpatchset@localhost.localdomain>	 <20080225115550.23920.43199.sendpatchset@localhost.localdomain>	 <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com>	 <47C2F86A.9010709@linux.vnet.ibm.com>	 <6599ad830802250932s5eaa3bcchbfc49fe0e76d3f7d@mail.gmail.com>	 <47C2FCC1.7090203@linux.vnet.ibm.com> <47C30EDC.4060005@google.com>	 <47C38127.2000109@cn.fujitsu.com> <6599ad830802260058m28d8f46djc83f47e19e2946a7@mail.gmail.com>
In-Reply-To: <6599ad830802260058m28d8f46djc83f47e19e2946a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Feb 25, 2008 at 7:01 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>  >
>>  > - foo doesn't show up in /proc/cgroups
>>
>>  Or we can print out the disable flag, maybe this will be better?
>>  Because we can distinguish from disabled and not compiled in from
>>
>> /proc/cgroups.
> 
> Certainly possible, if people felt it was useful.
> 
>>  > - foo isn't auto-mounted if you mount all cgroups in a single hierarchy
>>  > - foo isn't visible as an individually mountable subsystem
>>
>>  You mentioned in a previous mail if we mount a disabled subsystem we
>>  will get an error. Here we just ignore the mount option. Which makes
>>  more sense ?
>>
> 
> No, we don't ignore the mount option - we give an error since it
> doesn't refer to a valid subsystem. (And in the first case there is no
> mount option).
> 

You are write, -ENOENT will be returned in this case. I made a mistake when
reading the prototype patch, thanks for the clarification. :)

