Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0CLQIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 11:08:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab0CLQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 11:08:54 -0500
Message-ID: <4B9A66E9.7060300@redhat.com>
Date: Fri, 12 Mar 2010 08:08:09 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100225 Fedora/3.0.2-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Sharyathi Nagesh <sharyath@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: sched_getaffinity() allow less than NR_CPUS length
References: <20100312161316.9520.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100312161316.9520.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/11/2010 11:15 PM, KOSAKI Motohiro wrote:
> Reported-by: Sharyathi Nagesh <sharyath@in.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Ulrich Drepper <drepper@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)

If this isn't creating problems with hotplug CPUs:

Acked-by: Ulrich Drepper <drepper@redhat.com>

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuaZukACgkQ2ijCOnn/RHRu9ACeNyLYw8q4ltCKxVOZme2at4tm
6DwAoJ6wz/weZnO5T3GJag/XsnfytCTu
=k2Dv
-----END PGP SIGNATURE-----
