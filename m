Return-Path: <linux-kernel-owner+w=401wt.eu-S1031158AbXDSFWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031158AbXDSFWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 01:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031165AbXDSFWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 01:22:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:12381 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031158AbXDSFWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 01:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rfEfwwxJMVKWZziOK+awsT4jOEHkWRfgp2O0wFE6LSp80Az15Bhx8itqtgQcbwsdWiBc842tcJyDUoYfaOhDtLC0NxmLxPNmud+4jey46RFkS10DxqysyX4c5UxJs0MA7zy81BjYFSiXWxNLsPrgdtyRsFqI1ZgARzTpWvZhld0=
Message-ID: <2ff216280704182222w32d46b34u4168cf859032520a@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:52:44 +0530
From: "Abhijit Bhopatkar" <bainonline@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] [RFC] Throttle swappiness for interactive tasks
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, akpm@osdl.org, jgarzik@pobox.com,
       "Chris Snook" <csnook@redhat.com>
In-Reply-To: <4626F038.8020606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>
	 <46268519.7080702@redhat.com>
	 <2ff216280704182014h6ff2eed3g4301ee8d1bfbed14@mail.gmail.com>
	 <4626F038.8020606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I just wanted to know weather its worth going forward or we have
> > better reasons to discount any such direction?
>
> The reason that the wrong pages get swapped out sometimes
> could be due to a side effect of the way the swappiness
> policy is implemented.
>
> While the VM only reclaims page cache pages, it will still
> rotate through the anonymous pages on the LRU list, which
> effectively randomizes the order of those pages on the list.

In my mind i find it fundamentally wrong to separate anon pages from
page cache. It should rather be lot more dependent on which task
accessed them last. Although it seems due to some twisted relationships
bet anon pages and interactive tasks separating them improves it.
Am i missing something here?

> I need to get back to benchmarking my patch to split the
> lists - anonymous and other swap backed pages on one set
> of pageout lists, filesystem backed pages on another list.
<snip>
> Unfortunately my main desktop system at home depends on
> Xen, so it's not as easy to use that patch there :(
>

Can you send me those patches please or point me to where i can find those?

Abhijit
