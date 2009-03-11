Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZCKF6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZCKF6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 01:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZCKF5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 01:57:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:36677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZCKF5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 01:57:52 -0400
Message-ID: <49B75292.6090208@kernel.org>
Date: Wed, 11 Mar 2009 14:56:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [GIT PULL] pull request for safe part
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 05:56:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>  0001-linker-script-define-__per_cpu_load-on-all-SMP-capa.patch
>  0002-percpu-make-x86-addr-pcpu-ptr-conversion-macros.patch
>  0003-percpu-more-flexibility-for-dyn_size-of-pcpu_setup.patch
>  0004-percpu-generalize-embedding-first-chunk-setup-helpe.patch

I left the above four patches which shouldn't cause disruption on
archs in #tj-percpu and put the recent alignment warning fix on top of
it.

>  0005-percpu-use-dynamic-percpu-allocator-as-the-default.patch

and moved this one to #tj-percpu-exp.  I'll move it into #tj-percpu
once it gets confirmed.  So, pulling from #tj-percpu should be safe
now.

Thanks.

-- 
tejun
