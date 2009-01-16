Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZAPKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZAPKWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbZAPKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:21:32 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:49087 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765969AbZAPKVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:21:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vob7rqWl/50QH+yaRW0RONShVf1L4sCck2f9nJQH9VfRTzrdizzwXsaRFyQ0ZGZag+owEvA9KvQTuaw7S3gzVqMYPnWbQAB6glnd/UK90eBz1KlfVupuNb2lRgQlgls3wUQhypRmIfCchBU1gy1/AD64Sg15UvvVG2BW7K2IIcg=  ;
X-YMail-OSG: _19hwIsVM1mE1fmju4SEQQVZv5xu.W0qXeIqG7_.KfP7FlYVv5Nzk6.GOjEbIkpVw3LMy46d068yr7wjEgeMgZrsFqRuoF8Qp1Ol9NpgSprMsqU5vNjGG_iym3UdKM0Kss4oWif9XGZ3rNqYXJqXrlT7iA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 21:21:07 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <20090115135236.GB29283@parisc-linux.org> <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
In-Reply-To: <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901162121.09128.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 21:16:31 Pekka Enberg wrote:
> On Thu, Jan 15, 2009 at 11:46:09AM +0200, Pekka Enberg wrote:
> >> It would also be nice if someone could do the performance analysis on
> >> the SLUB bug. I ran sysbench in oltp mode here and the results look
> >> like this:
> >>
> >>   [ number of transactions per second from 10 runs. ]
> >>
> >>                    min      max      avg      sd
> >>   2.6.29-rc1-slab  833.77   852.32   845.10   4.72
> >>   2.6.29-rc1-slub  823.61   851.94   836.74   8.57

> I had lockdep enabled in my config so I ran the tests again with
> x86-64 defconfig and I'm back to square one:
>
>   [ number of transactions per second from 10 runs, bigger is better ]
>
>                    min      max      avg      sd
>   2.6.29-rc1-slab  802.02   805.37   803.93   0.97
>   2.6.29-rc1-slub  807.78   811.20   809.86   1.05

Hm, I wonder why it is going slower with lockdep disabled?
Did something else change?

