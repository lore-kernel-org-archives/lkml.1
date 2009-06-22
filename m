Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZFVPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZFVPnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbZFVPm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:42:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbZFVPm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:42:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [RFC] IO scheduler based io controller (V5)
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<20090621152116.GC3728@balbir.in.ibm.com>
	<20090622153030.GA15600@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Jun 2009 11:40:42 -0400
In-Reply-To: <20090622153030.GA15600@redhat.com> (Vivek Goyal's message of
	"Mon, 22 Jun 2009 11:30:31 -0400")
Message-ID: <x497hz4l1j9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
>> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
>> 
>> > 
>> > Hi All,
>> > 
>> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
>> [snip]
>> 
>> > Testing
>> > =======
>> >
>> 
>> [snip]
>> 
>> I've not been reading through the discussions in complete detail, but
>> I see no reference to async reads or aio. In the case of aio, aio
>> presumes the context of the user space process. Could you elaborate on
>> any testing you've done with these cases? 
>> 
>
> Hi Balbir,
>
> So far I had not done any testing with AIO. I have done some just now.
> Here are the results.
>
> Test1 (AIO reads)
> ================
> Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
> respectively. I am using cfq scheduler. Following are some lines from my test
> script.
>
> ===================================================================
> fio_args="--ioengine=libaio --rw=read --size=512M"

AIO doesn't make sense without O_DIRECT.

Cheers,
Jeff
