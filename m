Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbYIJKpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbYIJKpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIJKpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:45:02 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:45173 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752014AbYIJKpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:45:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ez2hPVNW3jk/NhwARB5HsH3+lcW8EWG7S1wHZkzArIE+zm+q80ejsMAd9+eNdETYwTXpFfmLR23aR2GV1Qnd9kN9TMcTZ+rT5Ivrwj7QuMPzKy1yIkiitaA1BuhhZN6m18FdKZEKnUnr+aUeiG+y7jR0rqQA8WytRGCQLwtTbKc=  ;
X-YMail-OSG: XMwZQSIVM1na_5vjA32QGUCjOf1ijW1kXMV73FOtmAtSh2ntWU20UhIitkPYdmNeA0AqEgsdfWZaguMcCbXEfDxugLxweoOGPW1WUrBerZXXGyqfqkMEQ3qj7gTRryA9GrSfXx37nklZydF27WIskwrN
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct page
Date: Thu, 11 Sep 2008 06:44:37 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <48C66AF8.5070505@linux.vnet.ibm.com> <20080910012048.GA32752@balbir.in.ibm.com> <20080910104940.a7ec9b5a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080910104940.a7ec9b5a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110644.39334.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 11:49, KAMEZAWA Hiroyuki wrote:
> On Tue, 9 Sep 2008 18:20:48 -0700
>
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-09-09
> > 21:30:12]: OK, here is approach #2, it works for me and gives me really
> > good performance (surpassing even the current memory controller). I am
> > seeing almost a 7% increase
>
> This number is from pre-allcation, maybe.
> We really do alloc-at-boot all page_cgroup ? This seems a big change.

It seems really nice to me -- we get the best of both worlds, less overhead
for those who don't enable the memory controller, and even better
performance for those who do.

Are you expecting many users to want to turn this on and off at runtime?
I wouldn't expect so, but I don't know enough about them.
