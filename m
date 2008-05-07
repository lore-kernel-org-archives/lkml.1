Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYEGCNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYEGCNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYEGCNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:13:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbYEGCNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:13:31 -0400
Message-ID: <48210FFC.4080403@cn.fujitsu.com>
Date: Wed, 07 May 2008 10:12:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
References: <48210101.1070205@google.com>	<20080506183841.e1771032.akpm@linux-foundation.org>	<482109E5.5050204@cn.fujitsu.com>	<20080506204946.7754302d.pj@sgi.com>	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com> <20080506205852.8adaa0a2.pj@sgi.com>
In-Reply-To: <20080506205852.8adaa0a2.pj@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Paul M wrote:
>> I was just trying to get close to the original behaviour.
> 
> An honorable goal.
> 
> Li Zefan - would you be interested in generating a patch
> that fails -EINVAL for inputs outside the range of [-1 ... N]
> for whatever small positive N the kernel recognizes?
> 
> This seems like a minor enough difference that I for one
> don't have any problem with the current code, remapping
> all negative inputs to -1, going in, and then a follow-on
> patch changing that going in afterward.
> 
> Of course, if you or Seto-san prefer the current behaviour,
> it would be easy to persuade me to agree.
> 

I prefer to put a limit on it, but as Andrew just said, we don't
need to rush for this. But sure I'll post a patch if Seto-san
doesn't have an objection on this.
