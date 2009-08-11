Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZHKPBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZHKPBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZHKPBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:01:03 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:55866 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZHKPBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:01:02 -0400
Date: Tue, 11 Aug 2009 20:30:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, andi.kleen@intel.com,
       Pavel Emelianov <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale better (v4)
Message-ID: <20090811150057.GY7176@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090811144405.GW7176@balbir.in.ibm.com> <4A81863A.2050504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A81863A.2050504@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Prarit Bhargava <prarit@redhat.com> [2009-08-11 10:54:50]:

>
>
> Balbir Singh wrote:
>> Enhancement: Remove the overhead of root based resource counter accounting
>>
>>
>>   
>
> <snip>
>> Please test/review.
>>
>>   
> FWIW ...
>

Thanks for the testing!

> On a 64p/32G system running 2.6.31-git2-rc5, with RESOURCE_COUNTERS off,  
> "time make -j64" results in
>
> real    4m54.972s
> user    90m13.456s
> sys     50m19.711s
>
> On the same system, running 2.6.31-git2-rc5, with RESOURCE_COUNTERS on,
> plus Balbir's "Help Resource Counters Scale Better (v3)" patch, and this  
                                                     ^^^
                                        you mean (v4) right?
> patch, results in
>
> real    4m18.607s
> user    84m58.943s
> sys     50m52.682s
>

Without the patch and RESOURCE_COUNTERS do you see a big overhead. I'd
assume so, I am seeing it on my 24 way box that I have access to.

-- 
	Balbir
