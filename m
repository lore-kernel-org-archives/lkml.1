Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZI3UFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZI3UFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZI3UFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:05:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:35408 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755142AbZI3UFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:05:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/IFZ1p11rIHW5LV+6xAYk5KNRb3GECzVkhZgKdqq
	82UJNJTM6Sjfr0
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
In-Reply-To: <1254340730.7695.32.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 22:05:39 +0200
Message-Id: <1254341139.7695.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
>  		/*
> +		 * We may have seeky queues, don't throttle up just yet.
> +		 */
> +		if (time_before(jiffies, cfqd->last_seeker + CIC_SEEK_THR))
> +			return 0;
> +

bzzzt.  Window too large, but the though is to let them overload, but
not instantly.

	-Mike

