Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYIID7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYIID7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYIID6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:58:47 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:23330 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753213AbYIID6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:58:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QxGuc1mcO6jrXhswyIXq7PLQDCkYeCLMsW7sUOOzypxCZr+sr8fMk0hq9DKBt9uCgkGLP3agkAmqnLbHnquwz5DsWGKV87kVCmJZcPU/UBb27IdOwexD/CZE48+3oh7ZvMP1wo/YQJokplCmiWwlFRpRb5JMzVL6DqaYUovxrjg=  ;
X-YMail-OSG: BvYaKQcVM1koD3iLIn_YuHK4DbTMfqvGqldKIq9nRQLL0zBErRE4cMj18fidibDW8.19KSpQ_T_qXCQg6A4LO4la_nrRe2mjt8XFNmmSuPjbRiAS3N2.im3KEr78HUc7roF6rZ2W6c1fqHeESmpDWkc4
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Date: Tue, 9 Sep 2008 13:58:27 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <20080908152810.GA12065@balbir.in.ibm.com> <20080909125751.37042345.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080909125751.37042345.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091358.28350.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 13:57, KAMEZAWA Hiroyuki wrote:
> On Mon, 8 Sep 2008 20:58:10 +0530
>
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > Sorry for the delay in sending out the new patch, I am traveling and
> > thus a little less responsive. Here is the update patch
>
> Hmm.. I've considered this approach for a while and my answer is that
> this is not what you really want.
>
> Because you just moves the placement of pointer from memmap to
> radix_tree both in GFP_KERNEL, total kernel memory usage is not changed.
> So, at least, you have to add some address calculation (as I did in March)
> to getting address of page_cgroup. But page_cgroup itself consumes 32bytes
> per page. Then.....

Just keep in mind that an important point is to make it more attractive
to configure cgroup into the kernel, but have it disabled or unused at
runtime.
