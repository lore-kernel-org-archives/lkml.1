Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbYHFDw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbYHFDw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYHFDua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:50:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:51027 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYHFDua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cNBeTBYmxdOC2ap2EAGY8q9NMwgLj85xnExI2A4C1FA9pWlKV1xhSK43lOZ72SsmQo
         pwSr4PDSCke+pmrN3rnAZFme+WwKEKIOlQUktgUs+cOTf7EE05SCN6+wd2J0BH0GzKKo
         QoRGgx3qP2t0S4RYNf5o/aJLFEvqxjShsA1EM=
Message-ID: <b6a2187b0808052050h35e2786fwfbf1e1dd5c37d8cf@mail.gmail.com>
Date: Wed, 6 Aug 2008 11:50:29 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48991B07.3050500@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <48991B07.3050500@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 11:31 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> You could try booting CONFIG_NR_CPUS=16 with maxcpus=8 (kernel command line option).
> If it boots you can then try bringing the rest of the cpus online manually

Ok,  booted with CONFIG_NR_CPUS=16 with maxcpus=8, but can't find the
rest of the CPUs.

I can only find cpu0 to cpu7 ...


drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu0
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu1
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu2
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu3
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu4
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu5
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu6
drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu7
-r--r--r--  1 root root 4096 Aug  6 19:41 online
-r--r--r--  1 root root 4096 Aug  6 19:39 possible
-r--r--r--  1 root root 4096 Aug  6 19:38 present
-rw-r--r--  1 root root 4096 Aug  6 19:38 sched_mc_power_savings

# cat online
0-7
# cat possible
0-23
# cat present
0-7

Thanks,
Jeff.
