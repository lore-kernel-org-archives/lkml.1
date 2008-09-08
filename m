Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYIHPnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYIHPnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYIHPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:42:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYIHPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:42:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QErdW/BAge2mH9epvQUHka/1TcJ7vQQdo1kRi0/+3s8mtWYGFNLDNkb5BdgPbukFs
	BAP2t4IK/YuBV6Z0QlFsA==
Message-ID: <6599ad830809080842p222b83bfr419120979add3df3@mail.gmail.com>
Date: Mon, 8 Sep 2008 08:42:43 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48C4E012.4060400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B360CE.2010501@cn.fujitsu.com>
	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
	 <48B39319.7070403@cn.fujitsu.com>
	 <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
	 <48B4D81D.2040200@cn.fujitsu.com>
	 <6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com>
	 <48B69582.4000208@cn.fujitsu.com> <48C0C4F7.2080702@google.com>
	 <48C4E012.4060400@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 1:19 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
>> +             while (index < end) {
>> +                     int mid = (index + end) / 2;
>> +                     if (cgrp->tasks_pids[mid] == pid) {
>> +                             index = mid;
>> +                             break;
>> +                     } else if (cgrp->tasks_pids[mid] <= pid)
>
> (cgrp->tasks_pids[mid] <= pid) ===> (cgrp->tasks_pids[mid] < pid)

Given the "if" test directly above, those two are equivalent.

Paul
