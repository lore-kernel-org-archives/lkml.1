Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbZJHIfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbZJHIfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZJHIfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:35:18 -0400
Received: from trinity.develer.com ([83.149.158.210]:51307 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZJHIfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:35:17 -0400
Date: Thu, 8 Oct 2009 10:34:38 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, peterz@infradead.org,
       jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       riel@redhat.com
Subject: Re: More performance numbers (Was: Re: IO scheduler based IO
	controller V10)
Message-ID: <20091008083438.GC4220@linux>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <20090924143315.781cd0ac.akpm@linux-foundation.org> <20091008044251.GA3490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008044251.GA3490@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 12:42:51AM -0400, Vivek Goyal wrote:
> Apart from IO scheduler controller number, I also got a chance to run same
> tests with dm-ioband controller. I am posting these too. I am also
> planning to run similar numbers on Andrea's "max bw" controller also.
> Should be able to post those numbers also in 2-3 days.

For those who are interested (expecially to help Vivek to test all this
stuff) here the all-in-one patchset of the io-throttle controller,
rebased to 2.6.31:
http://www.develer.com/~arighi/linux/patches/io-throttle/old/cgroup-io-throttle-2.6.31.patch

And this one is v18 rebased to 2.6.32-rc3:
http://www.develer.com/~arighi/linux/patches/io-throttle/cgroup-io-throttle-v18.patch

Thanks,
-Andrea
