Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZHKO6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZHKO6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZHKO6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:58:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbZHKO6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:58:10 -0400
Message-ID: <4A81863A.2050504@redhat.com>
Date: Tue, 11 Aug 2009 10:54:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, andi.kleen@intel.com,
       Pavel Emelianov <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale better (v4)
References: <20090811144405.GW7176@balbir.in.ibm.com>
In-Reply-To: <20090811144405.GW7176@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Balbir Singh wrote:
> Enhancement: Remove the overhead of root based resource counter accounting
>
>
>   

<snip>
> Please test/review.
>
>   
FWIW ...

On a 64p/32G system running 2.6.31-git2-rc5, with RESOURCE_COUNTERS off, 
"time make -j64" results in

real    4m54.972s
user    90m13.456s
sys     50m19.711s

On the same system, running 2.6.31-git2-rc5, with RESOURCE_COUNTERS on,
plus Balbir's "Help Resource Counters Scale Better (v3)" patch, and this 
patch, results in

 real    4m18.607s
user    84m58.943s
sys     50m52.682s

P.
