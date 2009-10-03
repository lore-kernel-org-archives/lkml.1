Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZJCRrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZJCRrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZJCRrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:47:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbZJCRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:47:32 -0400
Date: Sat, 3 Oct 2009 10:45:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
 controller V10)
In-Reply-To: <20091003173532.GG31616@kernel.dk>
Message-ID: <alpine.LFD.2.01.0910031042560.6996@localhost.localdomain>
References: <1254549378.8299.21.camel@marge.simson.net> <20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com> <20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com> <1254578553.7499.5.camel@marge.simson.net>
 <20091003142840.GE31616@kernel.dk> <1254581496.8293.8.camel@marge.simson.net> <20091003151445.GF31616@kernel.dk> <1254585420.7539.2.camel@marge.simson.net> <20091003173532.GG31616@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Oct 2009, Jens Axboe wrote:
> 
> Doesn't look too bad, all things considered. Apart from "stock" cfq,
> it's consistent. And being consistent is a Good Thing. Performance wise,
> it's losing out to "stock" but looks pretty competetive otherwise.

I agree. And I think the numbers for the kconsole test are pretty 
conclusive. That's a big improvement (on top of the already very 
impressive improvement).

> So far that looks like a winner. The dictator wanted good latency, he's
> getting good latency. I'll continue working on this on monday, while I'm
> waiting for delivery of the Trabant.

Trabant?

As in the car? 

Why would you _ever_ wait for delivery? The sane option would be to try to 
hide, or run away?

			Linus
